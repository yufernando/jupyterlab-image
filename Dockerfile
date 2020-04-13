# This is the latest Jupyterlab v1 image, compatible with jupyterlab-vim
# FROM jupyter/scipy-notebook:e255f1aa00b2
# FROM jupyter/scipy-notebook:d2c9b7ad84e2
# FROM jupyter/scipy-notebook:abdb27a6dfbb
FROM jupyter/scipy-notebook:a330137134e7

RUN jupyter labextension install jupyterlab_vim
RUN pip install altair

WORKDIR /home/jovyan/work
