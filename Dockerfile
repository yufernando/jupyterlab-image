# My Custom JupyterLab Image (September 2021)
FROM jupyter/scipy-notebook:lab-3.1.12

LABEL maintainer="Fernando Yu <yufernando@gmail.com>"

# SETUP
USER root
ENV HOME /root
RUN apt update && apt -y upgrade && \
    apt install -y make

# Get Root dotfiles
RUN git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles "${HOME}/.dotfiles"

# CHECK IF 2_install.sh HAS CHANGES
ADD https://api.github.com/repos/yufernando/dotfiles/contents/2_install.sh?ref=ubuntu /tmp/2_install-version.json

# ROOT INSTALL
WORKDIR "${HOME}/.dotfiles"
RUN make install

# USER INSTALL
USER ${NB_UID}
ENV HOME "/home/${NB_USER}"
# Get User dotfiles
RUN git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles "${HOME}/.dotfiles"
WORKDIR "${HOME}/.dotfiles"
RUN make install

# INSTALL PYTHON PACKAGES
# Install JupyterLab extensions
RUN pip install                          \
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

# CHECK IF DOTFILES HAVE CHANGES
ADD https://api.github.com/repos/yufernando/dotfiles/git/refs/heads/ubuntu /tmp/dotfiles-version.json

# ROOT DOTFILES CONFIG
USER root
ENV HOME /root
WORKDIR "${HOME}/.dotfiles"
RUN make config && \
    # Fix oh-my-zsh permission bug
    sed -i '1i ZSH_DISABLE_COMPFIX=true' "${HOME}/.zshrc"

# USER DOTFILES CONFIG
USER ${NB_UID}
ENV HOME "/home/${NB_USER}"
WORKDIR "${HOME}/.dotfiles"
RUN make config && \
    # Fix oh-my-zsh permission bug
    sed -i '1i ZSH_DISABLE_COMPFIX=true' "${HOME}/.zshrc" && \
    /bin/zsh -ic "compaudit | xargs chmod g-w,o-w"

WORKDIR "${HOME}/work"
