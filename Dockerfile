# November 2020
FROM jupyter/scipy-notebook:lab-3.0.16

# RUN mkdir -p /home/jovyan/.jupyter

# Install extensions
RUN jupyter labextension install @axlair/jupyterlab_vim --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install @oriolmirosa/jupyterlab_materialdarker && \ 
    conda install -c conda-forge jupyterlab-git && \
    pip install jupyterlab-quickopen && \
    jupyter labextension install @parente/jupyterlab-quickopen --no-build && \
#from https://github.com/jupyterlab/jupyterlab/issues/4930#issuecomment-446597498
    jupyter lab build --minimize=False && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local && \
    rm -rf $HOME/.cache/yarn && \
    fix-permissions $CONDA_DIR $HOME

# Install packages
RUN conda install --quiet --yes \ 
    altair \
    nbdime \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR $HOME

# Copy settings to jupyterlab
RUN mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && \
    mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension
ADD jupyterlab-settings /home/jovyan/.jupyter/lab/user-settings/@jupyterlab

# COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

WORKDIR /home/jovyan/work
