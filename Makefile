# My personal Jupyterlab image
# Builds custom image based on jupyter/scipy-notebook
#
# Example:
#   make build tag=lab-3.3.3			-> builds an image with 3 tags: commit, latest and tag
#   make build-no-cache tag=lab-3.3.3	-> builds from scratch, ignoring docker cache
#   make push							-> push all images to Docker hub
#   make build tag=smk-3.3.3 dockerfile=Dockerfile-snakemake -> alternative Dockerfile
#
# Routine workflow:
# 1. Add changes to Dockerfile
# 2. $ make build tag=lab-3.3.3
# 3. $ make push

img 	:= yufernando/jupyterlab
commit 	:= $$(git rev-parse --short HEAD)
tag		:= latest
port	:= 8888
name	:= jupyterlab
dockerfile := Dockerfile

.PHONY: build build-no-cache tag push run

build: ## Build image
	@docker build -f $(dockerfile) -t $(img):$(commit) .
	@docker tag $(img):$(commit) $(img):latest
	@docker tag $(img):$(commit) ${img}:$(tag)

build-no-cache: ## Build image without cache
	@docker build -f $(dockerfile) -t $(img):$(commit) . --no-cache
	@docker tag $(img):$(commit) $(img):latest
	@docker tag $(img):$(commit) ${img}:$(tag)

tag: ## Tag image
	@docker tag $(img):$(commit) ${img}:$(tag)

push: ## Push to Dockerhub
	@docker push $(img):$(commit)
	@docker push $(img):latest
	@docker push $(img):$(tag)

run: ## Run Jupyterlab image
	@docker run --rm -p $(port):8888 -e JUPYTER_ENABLE_LAB=yes --name $(name) $(img)

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

