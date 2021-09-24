# Makefile to build my personal Jupyterlab image
#
# Example:
#   make build tag=lab-3.1.12       -> builds an image with 3 tags: commit, latest and tag
#   make build-force tag=lab-3.1.12 -> builds from scratch, ignoring docker cache
#   make push                      -> push all images to Docker hub
#
# Routine workflow:
# 1. Add changes to Dockerfile
# 2. $ make build tag=lab-3.1.12
# 3. $ make push

img 	:= yufernando/jupyterlab
commit 	:= $$(git rev-parse --short HEAD)
tag		:= latest
port	:= 8888
name	:= jupyterlab

.PHONY: build build-force tag push run

build: 
	@docker build -t $(img):$(commit) .
	@docker tag $(img):$(commit) $(img):latest
	@docker tag $(img):$(commit) ${img}:$(tag)

build-force:
	@docker build -t $(img):$(commit) . --no-cache
	@docker tag $(img):$(commit) $(img):latest
	@docker tag $(img):$(commit) ${img}:$(tag)

tag:
	@docker tag $(img):$(commit) ${img}:$(tag)

push:
	@docker push $(img):$(commit)
	@docker push $(img):latest
	@docker push $(img):$(tag)

run:
	@docker run --rm -p $(port):8888 -e JUPYTER_ENABLE_LAB=yes --name $(name) $(img)
