# JupyterLab Docker Image

This is the repository of my custom JupyterLab Docker image. 

Specs:

- Jupyterlab 3.1.12
    - Vim Keybindings
    - Jupyterlab Table of Contents
    - Jupyterlab-git extension
- NBDime for easy diffing Jupyter Notebooks
- Terminal: Zsh, Oh-my-zsh
- Linux utilities: neovim, curl, tmux, ripgrep

## Instructions: build and push the image

Clone the repository:
```
git clone git@github.com/yufernando/jupyterlab-image
cd jupyterlab-image
```

Build the image:
```
make build
```
This will create two tags: `latest` and the latest commit hash.

You can also add a third custom tag:
```
make build tag=lab-3.3.4
```

Push all tags to Docker Hub:
```
make push
```

Run `make help` to see a description of Makefile rules.

## Run the Docker container

Run the image created above:
```
make run
```

## Using docker-compose

The docker-compose script mounts a volume from the host folder `notebooks`.

`docker-compose run --rm lab`
`docker-compose run --rm c-lang`

Remove the container:

`docker-compose down`
