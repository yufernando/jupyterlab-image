FROM jupyter/scipy-notebook

RUN jupyter labextension install jupyterlab_vim
RUN pip install altair

WORKDIR /home/jovyan/work
