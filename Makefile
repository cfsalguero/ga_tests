default: help

help:                           ## Display this help message
	@echo "Please use \`make <target>\` where <target> is one of:"
	@grep -h '^[a-zA-Z]' $(MAKEFILE_LIST) | \
		awk -F ':.*?## ' 'NF==2 {printf "  %-26s%s\n", $$1, $$2}'
	@echo
	@echo "To test DBaaS components with minikube:"
	@echo "Start minikube: minikube start --cpus=2 --nodes=3 --kubernetes-version=v1.20.0"
	@echo "ENABLE_DBAAS=1 NETWORK=minikube make env-up"


gen: clean                      ## Generate files
	go generate ./...


TEST_FLAGS ?= -timeout=180s
TEST_RUN_UPDATE ?= 0
TEST_FILES ?= ./...

test:                           ## Run tests
	go test $(TEST_FLAGS) -p 1 -race $(TEST_FILES)

test-cover:                     ## Run tests and collect per-package coverage information
	go test $(TEST_FLAGS) -p 1 -race -coverprofile=cover.out -covermode=atomic -coverpkg=$(TEST_FILES) $(TEST_FILES)

init:                 ## Install tools
	rm -rf bin/*
	cd tools && go generate -x -tags=tools

	# Install golangci-lint
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b ./bin v1.51.2 # Version should match specified in CI

check-license:          ## Run license header checks against source files
	bin/license-eye -c .licenserc.yaml header check

check-all: check-license check    ## Run golangci linter to check for changes against main
	bin/golangci-lint run -c=.golangci.yml --new-from-rev=main

FILES = $(shell find . -type f -name '*.go')

format:               ## Format source code
	bin/gofumpt -l -w $(FILES)
	bin/goimports -local github.com/percona/pmm -l -w $(FILES)
	bin/gci write --section Standard --section Default --section "Prefix(github.com/percona/pmm)" $(FILES)
	bin/buf format api -w

