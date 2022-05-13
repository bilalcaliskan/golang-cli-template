# golang-cli-template
[![CI](https://github.com/bilalcaliskan/golang-cli-template/workflows/CI/badge.svg?event=push)](https://github.com/bilalcaliskan/golang-cli-template/actions?query=workflow%3ACI)
[![Docker pulls](https://img.shields.io/docker/pulls/bilalcaliskan/golang-cli-template)](https://hub.docker.com/r/bilalcaliskan/golang-cli-template/)
[![Go Report Card](https://goreportcard.com/badge/github.com/bilalcaliskan/golang-cli-template)](https://goreportcard.com/report/github.com/bilalcaliskan/golang-cli-template)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=bilalcaliskan_golang-cli-template&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=bilalcaliskan_golang-cli-template)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=bilalcaliskan_golang-cli-template&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=bilalcaliskan_golang-cli-template)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=bilalcaliskan_golang-cli-template&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=bilalcaliskan_golang-cli-template)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=bilalcaliskan_golang-cli-template&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=bilalcaliskan_golang-cli-template)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=bilalcaliskan_golang-cli-template&metric=coverage)](https://sonarcloud.io/summary/new_code?id=bilalcaliskan_golang-cli-template)
[![Release](https://img.shields.io/github/release/bilalcaliskan/golang-cli-template.svg)](https://github.com/bilalcaliskan/golang-cli-template/releases/latest)
[![Go version](https://img.shields.io/github/go-mod/go-version/bilalcaliskan/golang-cli-template)](https://github.com/bilalcaliskan/golang-cli-template)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Setup
- [ ] Find and replace all occurrences of `golang-cli-template` with your desired project name
- [ ] Find and replace all occurrences of `GolangCliTemplate` with upper camel case form of your desired project name
- [ ] Find and replace all occurrences of `golangCliTemplate` with lower camel case form of your desired project name
- [ ] Ensure created repository has been added to https://sonarcloud.io/
- [ ] Ensure `SONAR_TOKEN` has been added as repository secret
- [ ] Ensure `DOCKER_PASSWORD` repository secret has been added
- [ ] To create banner:
  - [ ] Generate a banner from [here](https://devops.datenkollektiv.de/banner.txt/index.html)
  - [ ] Uncomment required lines in [cmd/root.go](cmd/root.go)
  - [ ] Fetch https://github.com/dimiro1/banner
- [ ] Remove all commented lines on files on [.github/workflows](.github/workflows) directory
- [ ] If you want to release as Formula, add `TAP_GITHUB_TOKEN` secret and uncomment brew related configurations on [.goreleaser.yaml](.goreleaser.yaml)

## Used Libraries
- [spf13/cobra](https://github.com/spf13/cobra)
- [stretchr/testify](https://github.com/stretchr/testify)
- [go.uber.org/automaxprocs](https://go.uber.org/automaxprocs)
- [go.uber.org/zap](https://go.uber.org/zap)
