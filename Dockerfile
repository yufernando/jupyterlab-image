FROM jupyter/scipy-notebook:42f4c82a07ff

RUN pip install altair
# RUN mkdir -p /home/jovyan/.jupyter

RUN jupyter labextension install @axlair/jupyterlab_vim --no-build && \
#from https://github.com/jupyterlab/jupyterlab/issues/4930#issuecomment-446597498
    jupyter lab build --minimize=False && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local && \
    rm -rf $HOME/.cache/yarn && \
    fix-permissions $CONDA_DIR $HOME

# COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

WORKDIR /home/jovyan/work
