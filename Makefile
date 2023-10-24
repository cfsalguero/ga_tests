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


PMM_TEST_FLAGS ?= -timeout=180s
PMM_TEST_RUN_UPDATE ?= 0
PMM_TEST_FILES ?= ./...

test:                           ## Run tests
	go test $(PMM_TEST_FLAGS) -p 1 -race $(PMM_TEST_FILES)

test-cover:                     ## Run tests and collect per-package coverage information
	go test $(PMM_TEST_FLAGS) -p 1 -race -coverprofile=cover.out -covermode=atomic -coverpkg=$(PMM_TEST_FILES) $(PMM_TEST_FILES)

