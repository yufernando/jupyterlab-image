# JupyterLab Docker

This repository contains docker files for a Jupyter Scipy Notebook with Vim keybindings. 

## Build a Docker image

```
git clone git@github.com/yufernando/jupyterlab-docker
cd jupyterlab-docker
docker build -t yufernando/jupyterlab-vim .
```

### (Optional) Push to Docker Hub

```
docker push yufernando/jupyterlab-vim
```

## Run the Docker container

Run the image created in the first above:
```
docker run --rm -p 8888:8888 -v $PWD:/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes jupyterlab-vim
```

Or run an image from Docker Hub:
```
docker run --rm -p 8888:8888 -v $PWD:/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes yufernando/jupyterlab-vim
```

## Using docker-compose

The docker-compose script mounts a volume from the host folder `notebooks`.

Clone the repository:

`git clone https://github.com/yufernando/jupyterlab-docker`

Start the Docker container

`docker-compose up`

Remove the container:

`docker-compose down`

## Using make

You can simplify the workflow above using `make`. The image is tagged with the latest commit hash. You can build it by running:

```
make build
```

Push it to Docker Hub:

```
make push
```
