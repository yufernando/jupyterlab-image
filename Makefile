NAME 	:= yufernando/jupyterlab
TAG 	:= $$(git rev-parse --short HEAD)
IMG 	:= ${NAME}:${TAG}
LATEST 	:= ${NAME}:latest

build: 
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker push ${NAME}

run:
	@docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes --name jupyterlab yufernando/jupyterlab

