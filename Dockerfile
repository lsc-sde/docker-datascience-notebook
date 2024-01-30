# Custom data science notebook for LANDER
ARG OWNER=vvcb
ARG BASE_CONTAINER=jupyter/datascience-notebook:2023-10-20
FROM $BASE_CONTAINER as base

LABEL maintainer="vvcb"
LABEL image="datascience-notebook"

COPY jupyter_notebook_config.json /etc/jupyter/jupyter_notebook_config.json
# COPY overrides.json ${CONDA_DIR}/share/jupyter/lab/settings/overrides.json
COPY environment.yaml environment.yaml

FROM base as updated
RUN mamba update --all --yes

FROM updated as configured 
RUN mamba env update --name base --file environment.yaml 

FROM configured as cleaned
RUN mamba clean --all -f -y
RUN rm environment.yaml
RUN fix-permissions "${CONDA_DIR}"
RUN fix-permissions "/home/${NB_USER}"

USER ${NB_USER}