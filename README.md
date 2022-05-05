# Custom Docker images

This is the repository of my custom Docker images.

## Specs:

### Jupyterlab
- Jupyterlab 3.1.12
    - Vim Keybindings
    - Jupyterlab Table of Contents
    - Jupyterlab-git extension
- NBDime for easy diffing Jupyter Notebooks
- Linux utilities: neovim, curl, tmux, ripgrep
- Terminal: Zsh, Oh-my-zsh

### C Language

- Ubuntu 20.04 LTS (Focal)
- GCC
- Linux utilities: neovim, curl, tmux, ripgrep
- Terminal: Zsh, Oh-my-zsh

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

You can add a custom tag:
```
make build tag=lab-3.3.4
```

Push the "latest" and "commit" tags to Dockerhub:
```
make push
```

Run `make help` to see a description of Makefile rules.

### Snakemake

The steps are the same as above but with the `tag=snakemake` flag:
```
make build tag=snakemake
make push tag=snakemake
```

### 

## Run the Docker container

Run the image and mount the working directory using make:
```
make run
```
Or docker-compose:

`docker-compose run --rm lab`
`docker-compose run --rm c-lang`

Remove the container:

edocker-compose down`
