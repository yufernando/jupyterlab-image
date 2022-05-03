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
#   - make build tag=snakemake dockerfile=Dockerfile-snakemake
#   - make push tag=snakemake
#
# C-Lang workflow:
#   - Add changes to Dockerfile-c-lang
#   - make build img=c-lang dockerfile=Dockerfile-c-lang
#   - make push img=c-lang
#
# Other rules:
#   make build tag=lab-[version]                             --> builds an image with 3 tags: commit, latest and tag
#   make build-no-cache tag=lab-[version]                    --> builds from scratch, ignoring docker cache
#   make push                                                --> push all images to Docker hub
#   make build tag=snakemake dockerfile=Dockerfile-snakemake --> alternative Dockerfile
#

img     := jupyterlab
name 	:= yufernando/$(img)
commit 	:= $$(git rev-parse --short HEAD)
tag		:= latest
port	:= 8888
dockerfile := Dockerfile

.PHONY: help build build-no-cache tag push run

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
	echo $(name)
	@docker build -f $(dockerfile) -t $(name):$(commit) .
	@docker tag $(name):$(commit) $(name):latest
	@docker tag $(name):$(commit) ${name}:$(tag)

build-no-cache: ## Build image without cache
	@docker build -f $(dockerfile) -t $(name):$(commit) . --no-cache
	@docker tag $(name):$(commit) $(name):latest
	@docker tag $(name):$(commit) ${name}:$(tag)

tag: ## Tag image
	@docker tag $(name):$(commit) ${name}:$(tag)

push: ## Push to Dockerhub
	@docker push $(name):$(commit)
	@docker push $(name):latest
	@docker push $(name):$(tag)

run: ## Run image in container
	docker compose run --rm $(name)
