LOCAL_BIN := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/.bin

DEFAULT_GO_TEST_CMD ?= go test ./... -race -p 1 -covermode=atomic
DEFAULT_GO_RUN_ARGS ?= ""

GOLANGCI_LINT_VERSION := latest
REVIVE_VERSION := v1.3.4
MOCKERY_VERSION := v2.39.1


.PHONY: all
all: clean tools lint test build

.PHONY: clean
clean:
	rm -rf $(LOCAL_BIN)

.PHONY: pre-commit-setup
pre-commit-setup:
	#python3 -m venv venv
	#source venv/bin/activate
	#pip3 install pre-commit
	pre-commit install -c build/ci/.pre-commit-config.yaml

.PHONY: tools
tools:  mockery-install golangci-lint-install revive-install vendor

.PHONY: mockery-install
mockery-install:
	GOBIN=$(LOCAL_BIN) go install github.com/vektra/mockery/v2@$(MOCKERY_VERSION)

.PHONY: golangci-lint-install
golangci-lint-install:
	GOBIN=$(LOCAL_BIN) go install github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION)

.PHONY: revive-install
revive-install:
	GOBIN=$(LOCAL_BIN) go install github.com/mgechev/revive@$(REVIVE_VERSION)

.PHONY: lint
lint: tools run-lint

.PHONY: run-lint
run-lint: lint-golangci-lint lint-revive

.PHONY: lint-golangci-lint
lint-golangci-lint:
	$(info running golangci-lint...)
	$(LOCAL_BIN)/golangci-lint -v run ./... || (echo golangci-lint returned an error, exiting!; sh -c 'exit 1';)

.PHONY: lint-revive
lint-revive:
	$(info running revive...)
	$(LOCAL_BIN)/revive -formatter=stylish -config=build/ci/.revive.toml -exclude ./vendor/... ./... || (echo revive returned an error, exiting!; sh -c 'exit 1';)

.PHONY: upgrade-deps
upgrade-deps: vendor
	for item in `grep -v 'indirect' go.mod | grep '/' | cut -d ' ' -f 1`; do \
		echo "trying to upgrade direct dependency $$item" ; \
		go get -u $$item ; \
  	done
	go mod tidy
	go mod vendor

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: vendor
vendor: tidy
	go mod vendor

.PHONY: test
test: generate-mocks vendor
	$(info starting the test for whole module...)
	$(DEFAULT_GO_TEST_CMD) -coverprofile=coverage.txt || (echo an error while testing, exiting!; sh -c 'exit 1';)

#.PHONY: test-unit
#test-unit: generate-mocks vendor
#	$(info starting the unit test for whole module...)
#	$(DEFAULT_GO_TEST_CMD) -tags "unit" -coverprofile=unit_coverage.txt || (echo an error while testing, exiting!; sh -c 'exit 1';)
#
#.PHONY: test-e2e
#test-e2e: generate-mocks vendor
#	$(info starting the e2e test for whole module...)
#	$(DEFAULT_GO_TEST_CMD) -tags "e2e" -coverprofile=e2e_coverage.txt || (echo an error while testing, exiting!; sh -c 'exit 1';)
#
#.PHONY: test-integration
#test-integration: generate-mocks vendor
#	$(info starting the integration test for whole module...)
#	$(DEFAULT_GO_TEST_CMD) -tags "integration" -coverprofile=integration_coverage.txt || (echo an error while testing, exiting!; sh -c 'exit 1';)

.PHONY: test-coverage
test-coverage: test
	go tool cover -html=coverage.txt -o cover.html
	open cover.html

.PHONY: build
build: vendor
	$(info building binary...)
	go build -o bin/main main.go || (echo an error while building binary, exiting!; sh -c 'exit 1';)

.PHONY: run
run: vendor
	go run main.go $(DEFAULT_GO_RUN_ARGS)

.PHONY: prepare-initial-project
GITHUB_USERNAME ?= $(shell read -p "Your Github username(ex: bilalcaliskan): " github_username; echo $$github_username)
PROJECT_NAME ?= $(shell read -p "'Kebab-cased' Project Name(ex: golang-cli-template): " project_name; echo $$project_name)
prepare-initial-project:
	grep -rl bilalcaliskan . --exclude={README.md,Makefile} --exclude-dir=.git --exclude-dir=.idea | xargs sed -i 's/bilalcaliskan/$(GITHUB_USERNAME)/g'
	grep -rl golang-cli-template . --exclude-dir=.git --exclude-dir=.idea | xargs sed -i 's/golang-cli-template/$(PROJECT_NAME)/g'
	echo "Please refer to *Additional nice-to-have steps* in README.md for additional features"
	echo "Cheers!"

.PHONY: generate-mocks
generate-mocks: mockery-install tidy vendor
	$(LOCAL_BIN)/mockery || (echo mockery returned an error, exiting!; sh -c 'exit 1';)
