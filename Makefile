# Makefile to build my personal jupyterlab image
#
# Example:
#   make build tag=lab-3.1.6
#   make push

img 	:= yufernando/jupyterlab
commit 	:= $$(git rev-parse --short HEAD)
tag		:= latest
port	:= 8888
name	:= jupyterlab

.PHONY: build tag push run

build: 
	@docker build -t $(img):$(commit) .
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
