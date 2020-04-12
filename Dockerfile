FROM jupyter/scipy-notebook:e255f1aa00b2

RUN jupyter labextension install jupyterlab_vim
RUN pip install altair

WORKDIR /home/jovyan/work
