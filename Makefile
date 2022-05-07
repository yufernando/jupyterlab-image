# Build Docker images
#
# Build custom Docker images for development with jupyterlab, snakemake and C.
#   tag: lab-[version], snakemake, latest (default: none)
#   name: jupyterlab, c-lang (default: jupyterlab)
#
# Jupyterlab workflow:
#   - Add changes to Dockerfile
#   make build tag=lab-[version]
#   make push
#
# Snakemake workflow:
#   - Add changes to Dockerfile-snakemake
#   make build tag=snakemake
#   make push tag=snakemake
#
# C-Lang workflow:
#   - Add changes to Dockerfile-c-lang
#   make build name=c-lang
#   make push name=c-lang
#
# Build and push all, no cache:
#   make all
#
# Remove images older than last commit:
# 	make pruneall
#   make prune
#   make prune name=c-lang
#
# Other rules:
#   make build-no-cache tag=lab-[version]                    -> Skip Docker cache
#   make build tag=snakemake dockerfile=Dockerfile-snakemake -> Specify alternative Dockerfile
#   make prune tag=snakemake                                 -> Prune only specified tag
#

SHELL := /bin/bash

name          := jupyterlab
user_name     := yufernando/$(name)
commit 	      := $$(git rev-parse --short HEAD)
before		  := $(commit)
before_name_tag:= $(user_name):$(before)
port	      := 8888
dockerfile    := Dockerfile
user_name_tag := $(user_name):$(tag)
ifndef tag
	user_name_tag := $(user_name)
endif

ifeq ($(tag), snakemake)
	dockerfile = Dockerfile-snakemake
endif
ifeq ($(name), c-lang)
	dockerfile = Dockerfile-c-lang
endif

.PHONY: help all build build-no-cache tag push run prune

help: ## View help
	@awk 'BEGIN {FS="^#+ ?"; header=1; body=0}; 			\
		  header == 1 {printf "\033[36m%s\033[0m\n", $$2}	\
		  /^#\s*$$/ {header=0; body=1; next}				\
		  body == 1 && /^#+ ?[^ \t]/ {print $$2} 			\
		  body == 1 && /^#+( {2,}| ?\t)/ {printf "\033[0;37m%s\033[0m\n", $$2} \
		  /^\s*$$/ {print "";exit}' $(MAKEFILE_LIST)
	@echo "Rules:"
	@grep -E '^[a-zA-Z_-]+:.*##[ \t]+.*$$' $(MAKEFILE_LIST) \
	| sort 													\
	| awk 'BEGIN {FS=":.*##[ \t]+"}; {printf "\033[36m%-20s\033[0m%s\n", $$1, $$2}'

all: ## Build and push all images with no cache
	$(MAKE) build-no-cache tag=lab-3.3.4
	$(MAKE) build-no-cache tag=snakemake
	$(MAKE) build-no-cache name=c-lang
	$(MAKE) push tag=lab-3.3.4
	$(MAKE) push tag=snakemake
	$(MAKE) push name=c-lang

build: ## Build image
	docker build -f $(dockerfile) -t $(user_name_tag) .
	@if [[ "$(tag)" = "snakemake" ]]; then exit 0; fi;	\
	docker tag $(user_name_tag) $(user_name):$(commit);	\
	docker tag $(user_name_tag) $(user_name):latest;

build-no-cache: ## Build image without cache
	docker build -f $(dockerfile) -t $(user_name_tag) . --no-cache
	@if [[ "$(tag)" = "snakemake" ]]; then exit 0; fi;	\
	docker tag $(user_name_tag) $(user_name):$(commit);	\
	docker tag $(user_name_tag) $(user_name):latest

tag: ## Tag image
	@docker tag $(user_name):$(commit) $(user_name_tag)

push: ## Push to Dockerhub
	@docker push $(user_name):$(commit)
	@docker push $(user_name):latest
	@docker push $(user_name_tag)

run: ## Run image in container
	docker compose run --rm $(user_name)

prune: ## Remove old images by name or tag
	@prune_images=$$(docker images -q -f 								\
		"reference=$(user_name_tag)" -f "before=$(before_name_tag)");	\
	if [ "$$prune_images" = "" ]; then 									\
		echo "Nothing to remove."; exit 0; 								\
	fi; 																\
	echo "WARNING! This will remove the following images:"; 			\
	docker images -f 													\
		"reference=$(user_name_tag)" -f "before=$(before_name_tag)"; 	\
	read -p "Are you sure you want to continue? [y/N] " answer; 		\
	if [ "$$answer" = "y" ]; then 										\
		docker image rm $$prune_images; 								\
	else 																\
		echo "Cancelled."; 												\
	fi

pruneall: ## Remove all old images
	$(MAKE) prune tag=lab-3.3.4
	$(MAKE) prune tag=snakemake
	$(MAKE) prune name=c-lang
