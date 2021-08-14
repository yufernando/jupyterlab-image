# July 2021
FROM jupyter/scipy-notebook:lab-3.1.4

# Install extensions
RUN pip install jupyterlab_vim && \
    pip install lckr-jupyterlab-variableinspector && \

# Install packages
RUN conda install --quiet --yes \ 
    nbdime \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR $HOME

WORKDIR /home/jovyan/work
