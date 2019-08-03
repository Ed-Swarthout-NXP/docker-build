# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Install tensorflow, jupyter notebook, and tensorflow tutorials
#
# Ed.Swarthout@nxp.com

# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t edswarthoutnxp/full-tf_nightly .

# docker run --name full-tf_nightly --net host --privileged -v /home/packages/sw/ml/tensorflow/models:/models -v /home/packages:/home/packages -v /home/packages/model/keras:/root/.keras --rm -it edswarthoutnxp/full-tf_nightly
# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

FROM build-tf_nightly

# for keras utils plot_model add graphviz, pydot and pydotplus
# needed for example notebooks: curl unzip wget

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    file \
    fonts-freefont-ttf \
    git \
    graphviz \
    gunicorn3 \
    jupyter-notebook \
    libc++1 \
    libgtk-3-0 \
    libusb-1.0 \
    python3 \
    python3-apt \
    python3-click \
    python3-distutils \
    python3-engineio \
    python3-flask \
    python3-flask-socketio \
    python3-grpcio \
    python3-gunicorn \
    python3-h5py \
    python3-ipywidgets \
    python3-itsdangerous \
    python3-markupsafe \
    python3-matplotlib \
    python3-numpy \
    python3-pandas \
    python3-pil \
    python3-pip \
    python3-pydot \
    python3-pydotplus \
    python3-seaborn \
    python3-six \
    python3-socketio-client \
    python3-termcolor \
    python3-wheel \
    python3-widgetsnbextension \
    python3-yaml \
    python3-zmq \
    unzip \
    wget

RUN python3 -m pip install -U \
    absl-py \
    astor \
    gast \
    google-pasta \
    keras-applications \
    keras-preprocessing \
    markdown \
    opt-einsum \
    setuptools \
    wrapt

#COPY --from=build-tf_nightly /tf_nightly-1.14.0-cp37-cp37m-linux_aarch64.whl tensorflow_hub /
RUN python3 -m pip install /tensorflow_pkg/tf_nightly-1.14.0-cp37-cp37m-linux_aarch64.whl tensorflow_hub

# set flags to enable xla
ENV TF_XLA_FLAGS=--tf_xla_cpu_global_jit XLA_FLAGS=--xla_hlo_profile

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

# Add tensorflow/docs/site/en notebooks
ADD docs-site-en-notebooks.tgz /notebook

# Allow remote access and use login password
COPY jupyter_notebook_config.py /root/.jupyter/

CMD ["jupyter", "notebook", "--allow-root", "--no-browser" ]

# cleanup
#RUN rm -rf /root/.cache/pip; rm -f /etc/apt/apt.conf.d/00aptproxy; rm -rf /var/lib/apt/lists

# Install imutils
COPY --from=u1904-opencv_dnn-builder-4.1.0 /home/packages/imutils/python3-imutils_0.5.2-1ed1_all.deb /
RUN cd / && dpkg -i python3-imutils_0.5.2-1ed1_all.deb && rm -f /python3-imutils*deb

RUN cd /root && \
    git clone --depth 1 https://github.com/Ed-Swarthout-NXP/flask-video-streaming.git -b NXP-opencv_dnn

WORKDIR "/"

# Access tensorflow tutorials with:
# http://ls1046afrwy:8888/notebooks/notebook/site/en/tutorials/keras/index.ipynb
