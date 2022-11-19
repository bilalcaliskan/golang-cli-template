GOLANGCI_LINT_VERSION = latest
REVIVE_VERSION = latest
GOIMPORTS_VERSION = latest
INEFFASSIGN_VERSION = latest
USERNAME ?= $(shell bash -c 'read -p "Username: " username; echo $$username')


LOCAL_BIN := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/.bin

.PHONY: all
all: clean tools lint fmt test build

.PHONY: clean
clean:
	rm -rf $(LOCAL_BIN)

.PHONY: tools
tools:  golangci-lint-install revive-install go-imports-install ineffassign-install
	go mod tidy

.PHONY: golangci-lint-install
golangci-lint-install:
	GOBIN=$(LOCAL_BIN) go install github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION)

.PHONY: revive-install
revive-install:
	GOBIN=$(LOCAL_BIN) go install github.com/mgechev/revive@$(REVIVE_VERSION)

.PHONY: ineffassign-install
ineffassign-install:
	GOBIN=$(LOCAL_BIN) go install github.com/gordonklaus/ineffassign@$(INEFFASSIGN_VERSION)

.PHONY: lint
lint: tools run-lint

.PHONY: run-lint
run-lint: lint-golangci-lint lint-revive

.PHONY: lint-golangci-lint
lint-golangci-lint:
	$(info running golangci-lint...)
	$(LOCAL_BIN)/golangci-lint -v run ./... || (echo golangci-lint returned an error, exiting!; sh -c 'exit 1';)
	$(info golangci-lint exited successfully!)

.PHONY: lint-revive
lint-revive:
	$(info running revive...)
	$(LOCAL_BIN)/revive -formatter=stylish -config=build/ci/.revive.toml -exclude ./vendor/... ./... || (echo revive returned an error, exiting!; sh -c 'exit 1';)
	$(info revive exited successfully!)

.PHONY: upgrade-direct-deps
upgrade-direct-deps: tidy
	for item in `grep -v 'indirect' go.mod | grep '/' | cut -d ' ' -f 1`; do \
		echo "trying to upgrade direct dependency $$item" ; \
		go get -u $$item ; \
  	done
	go mod tidy
	go mod vendor

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: run-goimports
run-goimports: go-imports-install
	for item in `find . -type f -name '*.go' -not -path './vendor/*'`; do \
		$(LOCAL_BIN)/goimports -l -w $$item ; \
	done

.PHONY: go-imports-install
go-imports-install:
	GOBIN=$(LOCAL_BIN) go install golang.org/x/tools/cmd/goimports@$(GOIMPORTS_VERSION)

.PHONY: fmt
fmt: tools run-fmt run-ineffassign run-vet

.PHONY: run-fmt
run-fmt:
	$(info running fmt...)
	go fmt ./... || (echo fmt returned an error, exiting!; sh -c 'exit 1';)
	$(info fmt exited successfully!)

.PHONY: run-ineffassign
run-ineffassign:
	$(info running ineffassign...)
	$(LOCAL_BIN)/ineffassign ./... || (echo ineffassign returned an error, exiting!; sh -c 'exit 1';)
	$(info ineffassign exited successfully!)

.PHONY: run-vet
run-vet:
	$(info running vet...)
	go vet ./... || (echo vet returned an error, exiting!; sh -c 'exit 1';)
	$(info vet exited successfully!)

.PHONY: test
test: tidy
	$(info starting the test for whole module...)
	go test -failfast -vet=off -race ./... || (echo an error while testing, exiting!; sh -c 'exit 1';)

.PHONY: test-with-coverage
test-with-coverage: tidy
	go test ./... -race -coverprofile=coverage.txt -covermode=atomic

.PHONY: update
update: tidy
	go get -u ./...

.PHONY: build
build: tidy
	$(info building binary...)
	go build -o bin/main main.go || (echo an error while building binary, exiting!; sh -c 'exit 1';)
	$(info binary built successfully!)

.PHONY: run
run: tidy
	go run main.go

.PHONY: cross-compile
cross-compile:
	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go
	GOOS=darwin GOARCH=386 go build -o bin/main-darwin-386 main.go
	GOOS=linux GOARCH=386 go build -o bin/main-linux-386 main.go
	GOOS=windows GOARCH=386 go build -o bin/main-windows-386 main.go
	GOOS=freebsd GOARCH=amd64 go build -o bin/main-freebsd-amd64 main.go
	GOOS=darwin GOARCH=amd64 go build -o bin/main-darwin-amd64 main.go
	GOOS=linux GOARCH=amd64 go build -o bin/main-linux-amd64 main.go
	GOOS=windows GOARCH=amd64 go build -o bin/main-windows-amd64 main.go


.PHONY: prepare-initial-project
PROJECT_NAME ?= $(shell read -p "'Kebab-cased' Project Name(ex: demo-project): " project_name; echo $$project_name)
PROJECT_NAME_PASCAL_CASE ?= $(shell read -p "'Pascal-cased' Project Name(ex: DemoProject): " project_name_pascal_case; echo $$project_name_pascal_case)
PROJECT_NAME_CAMEL_CASE ?= $(shell read -p "'Camel-cased' Project Name(ex: demoProject): " project_name_camel_case; echo $$project_name_camel_case)
prepare-initial-project:
	grep -rl demo-project . --exclude=README.md --exclude-dir=.git --exclude-dir=.idea | xargs sed -i 's/demo-project/$(PROJECT_NAME)/g'
	grep -rl DemoProject . --exclude=README.md --exclude-dir=.git --exclude-dir=.idea | xargs sed -i 's/DemoProject/$(PROJECT_NAME_PASCAL_CASE)/g'
	grep -rl demoProject . --exclude=README.md --exclude-dir=.git --exclude-dir=.idea | xargs sed -i 's/demoProject/$(PROJECT_NAME_CAMEL_CASE)/g'
	echo ""
	echo ""
	echo "Here are few manuel steps to check:"
	echo "  - Please ensure created repository has been added to \"https://sonarcloud.io/\""
	echo "  - Please ensure \"SONAR_TOKEN\" has been added as repository secret"
	echo "  - Please ensure \"DOCKER_USERNAME\" and \"DOCKER_PASSWORD\" repository secrets have been added to your repository if you want to dockerize app"
	echo "  - If you want to release as Formula, add \"TAP_GITHUB_TOKEN\" secret and uncomment brew related configurations on file \"build/package/.goreleaser.yaml\""
