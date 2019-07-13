# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Build tensorflow
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t build-tf_nightly .
# stages docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65

# docker run -it --name build-tf_nightly -v /home/packages/model:/home/packages/model -v /home/packages/model/keras:/root/.keras build-tf_nightly
# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

#ARG ARCH=aarch64

FROM ubuntu:19.04 as build-base-tf_nightly

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

# Note: Ensure there is a host entry for ubuntu-apt-cacher-ng IP address
COPY 00aptproxy-ubuntu-cacher-ng /etc/apt/apt.conf.d/00aptproxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libhdf5-dev \
    openjdk-8-jdk-headless \
    protobuf-compiler \
    python3-dev \
    python3-grpcio \
    python3-h5py \
    python3-numpy \
    python3-pil \
    python3-pip \
    python3-six \
    python3-wheel \
    python3-zmq \
    software-properties-common \
    unzip

# Must install setuptools first to fix:
#Collecting setuptools
#  Downloading https://files.pythonhosted.org/packages/ec/51/f45cea425fd5cb0b0380f5b0f048ebc1da5b417e48d304838c02d6288a1e/setuptools-41.0.1-py2.py3-none-any.whl (575kB)
#Collecting absl-py
#  Downloading https://files.pythonhosted.org/packages/da/3f/9b0355080b81b15ba6a9ffcf1f5ea39e307a2778b2f2dc8694724e8abd5b/absl-py-0.7.1.tar.gz (99kB)
#    Complete output from command python setup.py egg_info:
#    Traceback (most recent call last):
#      File "<string>", line 1, in <module>
#    ModuleNotFoundError: No module named 'setuptools'

RUN python3 -m pip install -U \
    setuptools

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

# Install bazel
ARG BAZEL_VERSION=0.26.1
COPY --from=build-bazel:0.26.1 /home/packages/bazel/output/bazel /usr/local/bin

# link to python3 to fix:
# ERROR: /home/packages/tensorflow/tensorflow/tensorflow/core/BUILD:2818:1: Executing genrule //tensorflow/core:version_info_gen failed (Exit 127)
# /usr/bin/env: 'python': No such file or directory
# Target //tensorflow/tools/pip_package:build_pip_package failed to build
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /tensorflow
RUN git clone --depth 1 --single-branch https://github.com/tensorflow/tensorflow.git

WORKDIR /tensorflow/tensorflow
RUN ./configure && echo "build --jobs=12" >> .bazelrc

# If needed, copy tf_configure overrides
#COPY r1.nightly.tf_configure.bazelrc .tf_configure.bazelrc

RUN bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package --nightly_flag /tensorflow_pkg

# Grab wheel with:
# docker cp /tensorflow_pkg/tf_nightly-1.14.9-cp37-cp37m-linux_${ARCH}.whl .
