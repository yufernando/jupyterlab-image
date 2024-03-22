# My Custom JupyterLab Image (March 2024)
# FROM quay.io/jupyter/scipy-notebook:lab-4.1.5 --> not compatible with vim
FROM quay.io/jupyter/scipy-notebook:lab-4.0.9

LABEL maintainer="Fernando Yu <yufernando@gmail.com>"

# SETUP
USER root
ENV HOME /root
RUN apt update && apt -y upgrade && \
    apt install -y make

# Get Root dotfiles
RUN git clone --single-branch --branch master https://github.com/yufernando/dotfiles "${HOME}/.dotfiles"

# CHECK IF 2_install.sh HAS CHANGES
ADD https://api.github.com/repos/yufernando/dotfiles/contents/scripts/3_install.sh?ref=master /tmp/3_install-version.json

# ROOT INSTALL
WORKDIR "${HOME}/.dotfiles"
RUN make install

# USER INSTALL
USER ${NB_UID}
ENV HOME "/home/${NB_USER}"
# Get User dotfiles
RUN git clone --single-branch --branch master https://github.com/yufernando/dotfiles "${HOME}/.dotfiles"
WORKDIR "${HOME}/.dotfiles"
RUN make install

# INSTALL PYTHON PACKAGES
RUN conda config --add channels defaults    && \
    conda config --add channels conda-forge && \
    mamba install --quiet --yes                \
    jupyterlab_vim                             \
    jupyterlab-variableinspector               \
    openpyxl                                   \
    nbdime                                     \
    nbstripout                                 \  
    jupyterlab_code_formatter                  \
    flake8                                     \
    black                                      \
    isort                                      \
    python-dotenv                              \
                                            && \
    conda clean --all -f -y
# RUN fix-permissions $CONDA_DIR $HOME  # creates permission errors

RUN nbstripout --install --global

# CHECK IF DOTFILES HAVE CHANGES
ADD https://api.github.com/repos/yufernando/dotfiles/contents/scripts/4_config.sh?ref=master /tmp/4_config-version.json
ADD https://api.github.com/repos/yufernando/dotfiles/git/refs/heads/master /tmp/dotfiles-version.json

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
    echo "let g:python3_host_prog  = '/opt/conda/bin/python3'" >> "${HOME}/.config/nvim/init.vim"
# RUN /bin/zsh -ic "compaudit | xargs chmod g-w,o-w"  # Generates error

WORKDIR "${HOME}/work"
