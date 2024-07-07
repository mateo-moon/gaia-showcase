
.PHONY: build deploy

all: build deploy

build: ## Build docker image
	@ docker build -t "$(whoami)/gaia:latest" .
deploy: ## Deploy docker image
	@ helm install --name gaia -n gaia ./helm
