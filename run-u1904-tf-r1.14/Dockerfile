# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Install tensorflow, jupyter notebook, and tensorflow tutorials
#
# Ed.Swarthout@nxp.com

# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t u1904-opencv_dnn-tf-r1.14 .

# docker run --name opencv_dnn-tf-r1.14 --net host --device=/dev/video0 -v /home/packages/model/keras:/root/.keras --rm -it u1904-opencv_dnn-tf-r1.14
# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

FROM edswarthoutnxp/u1904-run-opencv_dnn-base as u1904-opencv_dnn-tf-r1.14

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    jupyter-notebook \
    python3-grpcio \
    python3-h5py \
    python3-ipywidgets \
    python3-matplotlib \
    python3-pandas \
    python3-pil \
    python3-pip \
    python3-seaborn \
    python3-termcolor \
    python3-wheel \
    python3-widgetsnbextension \
    python3-zmq

RUN python3 -m pip install -U \
    absl-py \
    astor \
    gast \
    google-pasta \
    keras-applications \
    keras-preprocessing \
    markdown \
    setuptools \
    wrapt

# Add tensorflow/docs/site/en/tutorials notebooks
ADD tf-tutorials.tgz /notebook

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebook"

CMD ["jupyter", "notebook", "--allow-root", "--no-browser" ]

# set flags to enable xla
ENV TF_XLA_FLAGS=--tf_xla_cpu_global_jit XLA_FLAGS=--xla_hlo_profile

COPY --from=build-u1904-tf-r1.14 /tensorflow_pkg/tensorflow-1.14.0-cp37-cp37m-linux_aarch64.whl /
RUN python3 -m pip install /tensorflow-1.14.0-cp37-cp37m-linux_aarch64.whl tensorflow_hub && \
   rm /tensorflow-1.14.0-cp37-cp37m-linux_aarch64.whl

# cleanup
RUN rm -rf /root/.cache/pip; rm -f /etc/apt/apt.conf.d/00aptproxy; rm -rf /var/lib/apt/lists

# Allow remote access and use login password
COPY jupyter_notebook_config.py /root/.jupyter/

# Access tensorflow tutorials with:
# http://localhost:8888/notebooks/tutorials/keras/index.ipynb
