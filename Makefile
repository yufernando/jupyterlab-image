# Build Docker images
# Custom images for development with jupyterlab, snakemake and C.
# Tags: lab-[version], snakemake, c-lang
#
# Jupyterlab workflow:
#   - Add changes to Dockerfile
#   - make build tag=lab-[version]
#   - make push
#
# Snakemake workflow:
#   - Add changes to Dockerfile-snakemake
#   - make build tag=snakemake
#   - make push tag=snakemake
#
# C-Lang workflow:
#   - Add changes to Dockerfile-c-lang
#   - make build name=c-lang
#   - make push name=c-lang
#
# Prune old images:
#   make prune
#   make prune name=c-lang
#
# Other rules:
#   make build tag=lab-[version]                             --> builds an image with 3 tags: commit, latest and tag
#   make build-no-cache tag=lab-[version]                    --> builds from scratch, ignoring docker cache
#   make push                                                --> push all images to Docker hub
#   make build tag=snakemake dockerfile=Dockerfile-snakemake --> alternative Dockerfile
#

name          := jupyterlab
tag		      := latest
user_name     := yufernando/$(name)
user_name_tag := $(user_name):$(tag)
commit 	      := $$(git rev-parse --short HEAD)
since		  := $(commit)
since_name_tag:= $(user_name):$(since)
port	      := 8888
dockerfile    := Dockerfile

ifeq ($(tag), snakemake)
	dockerfile = Dockerfile-snakemake
endif
ifeq ($(name), c-lang)
	dockerfile = Dockerfile-c-lang
endif

.PHONY: help build build-no-cache tag push run prune

help: ## View help
	@awk 'BEGIN {FS="^#+ ?"; header=1; body=0}; \
		  header == 1 {printf "\033[36m%s\033[0m\n", $$2} \
		  /^#\s*$$/ {header=0; body=1; next} \
		  body == 1 && /^#+ ?[^ \t]/ {print $$2} \
		  body == 1 && /^#+( {2,}| ?\t)/ {printf "\033[0;37m%s\033[0m\n", $$2} \
		  /^\s*$$/ {print "";exit}' $(MAKEFILE_LIST)
	@echo "Rules:"
	@grep -E '^[a-zA-Z_-]+:.*##[ \t]+.*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS=":.*##[ \t]+"}; {printf "\033[36m%-20s\033[0m%s\n", $$1, $$2}'

build: ## Build image
	echo $(user_name)
	@docker build -f $(dockerfile) -t $(user_name):$(commit) .
	@docker tag $(user_name):$(commit) $(user_name):latest
	@docker tag $(user_name):$(commit) ${user_name}:$(tag)

build-no-cache: ## Build image without cache
	@docker build -f $(dockerfile) -t $(user_name):$(commit) . --no-cache
	@docker tag $(user_name):$(commit) $(user_name):latest
	@docker tag $(user_name):$(commit) ${user_name}:$(tag)

tag: ## Tag image
	@docker tag $(user_name):$(commit) ${user_name}:$(tag)

push: ## Push to Dockerhub
	@docker push $(user_name):$(commit)
	@docker push $(user_name):latest
	@docker push $(user_name):$(tag)

run: ## Run image in container
	docker compose run --rm $(user_name)

prune: ## Remove old images
	@if [ $(docker images --filter "reference=$(user_name):$(tag)" --filter "since=$(since_name_tag)") = ""]; then \
		echo "Nothing to remove."; exit 0; \
	fi; \
	echo "WARNING! This will remove the following images:"; \
	docker images --filter "reference=$(user_name):$(tag)" --filter "since=$(since_name_tag)"; \
	read -p "Are you sure you want to continue? [y/N] " answer; \
	if [ "$$answer" = "y" ]; then \
	docker images --filter "reference=$(user_name):$(tag)" --filter "since=$(since_name_tag)" --quiet | xargs docker image rm; \
	else \
		echo "Cancelled."; \
	fi
