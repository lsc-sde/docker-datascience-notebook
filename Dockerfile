# Custom data science notebook for LANDER
ARG OWNER=vvcb
ARG BASE_CONTAINER=jupyter/datascience-notebook:2023-01-09
FROM $BASE_CONTAINER

LABEL maintainer="vvcb"
LABEL image="datascience-notebook"

COPY jupyter_notebook_config.json /etc/jupyter/jupyter_notebook_config.json
# COPY overrides.json ${CONDA_DIR}/share/jupyter/lab/settings/overrides.json
COPY environment.yaml environment.yaml
RUN mamba update --all --yes \ 
    && mamba env update --name base --file environment.yaml \
    && mamba clean --all -f -y \
    && rm environment.yaml \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER ${NB_USER}