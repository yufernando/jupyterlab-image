# My Custom JupyterLab Image (September 2021)
FROM jupyter/scipy-notebook:lab-3.1.4

LABEL maintainer="Fernando Yu <yufernando@gmail.com>"

# Root
USER root
ENV HOME /root

# Setup zsh and linux tools
RUN apt update && apt -y upgrade     && \
    apt install -y make              && \
    # Configure root
    git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles && \ 
    cd ~/.dotfiles && make config_install

# User
USER $NB_UID
ENV HOME /home/jovyan

# Configure user
RUN git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles && \ 
    cd ~/.dotfiles && make config_install && \
    # Fix oh-my-zsh permission bug
    sed -i '1iZSH_DISABLE_COMPFIX=true' ~/.zshrc && \ 
# Install JupyterLab extensions
    pip install                          \
    jupyterlab_vim                       \
    lckr-jupyterlab-variableinspector    \
    openpyxl                             \
    && \
# Configure conda
    conda config --add channels defaults && \
    conda config --add channels conda-forge && \
# Conda packages
    conda install --quiet --yes          \
    nbdime                            && \
    conda clean --all -f -y           && \
    fix-permissions $CONDA_DIR $HOME

WORKDIR /home/jovyan/work
