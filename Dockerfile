# pull from devel image instead of base
FROM nvidia/cuda:12.9.1-devel-ubuntu22.04

# Set bash as the default shell
ENV SHELL=/bin/bash

# Create a working directory
WORKDIR /app/

# Build with some basic utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    apt-utils \
    vim \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# alias python='python3'
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install UV package manager
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# build with some basic python packages
RUN uv pip install --no-cache-dir \
    --system \
    numpy \
    torch \
    torchvision \
    torchaudio  \
    jupyterlab

# start jupyter lab
#CMD ["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]

# docker run --rm -it  \
#            -p 8888:8888  \
#            -e JUPYTER_TOKEN=passwd  \
#            tverous/pytorch-notebook:latest
#CMD ["jupyter", "notebook", "--NotebookApp.token='your_secret_token'"]

#docker run -it --rm -p 8888:8888 -e JUPYTER_TOKEN="your_secret_token" jupyter/base-notebook

#docker run -it --rm -p 8888:8888 jupyter/base-notebook start-notebook.py --NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$your_hashed_password_here'

#CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$your_hashed_password_here'"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--NotebookApp.token='12345'"]

#CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888","--allow-root", "--no-browser"]
EXPOSE  8888
