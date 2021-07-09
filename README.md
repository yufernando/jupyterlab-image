# JupyterLab Docker

This is the repository of my custom JupyterLab Docker image. 

Specs:

- Vim Keybindings.
- Jupyterlab Table of Contents.
- Jupyterlab-git extension.
- NBDime for easy diffing Jupyter Notebooks.

## Build the Docker image

Clone the repository, build the image and set name yufernando/jupyterlab:
```
git clone git@github.com/yufernando/jupyterlab-image
cd jupyterlab-image
docker build -t yufernando/jupyterlab .
```

### (Optional) Push to Docker Hub

```
docker push yufernando/jupyterlab
```

## Run the Docker container

Run the image created above:
```
docker run --rm -p 8888:8888 -v $PWD:/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes yufernando/jupyterlab
```
If it does not find it locally, it will pull the latest version from Docker Hub.

## Using docker-compose

The docker-compose script mounts a volume from the host folder `notebooks`.

Clone the repository:

`git clone https://github.com/yufernando/jupyterlab-image`

Start the Docker container

`docker-compose up`

Remove the container:

`docker-compose down`

## Using make

You can simplify the workflow above using `make`. 

You can build the image by running:
```
make build
```

This will create an image with two tags: the latest commit hash and "latest".

Then push the image with both tags to Docker Hub:

```
make push
```
