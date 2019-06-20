# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Build tensorflow
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t build-u1904-tf-r1.14 .

# docker run -it --name tf-r1.14-b -v /home/packages:/home/packages -v /home/packages/model/keras:/root/.keras build-u1904-tf-r1.14
# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

FROM u1904-opencv_dnn-builder-4.1.0 as build-u1904-tf-r1.14

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get update && apt-get install -y --no-install-recommends \
    libhdf5-dev \
    openjdk-8-jdk-headless \
    python3-grpcio \
    python3-h5py \
    python3-pil \
    python3-pip \
    python3-wheel \
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

ENV tf_dir=/home/packages/tensorflow arch=aarch64 tf_ver=1.14
ENV bdir=$tf_dir/tensorflow
RUN mkdir -p $tf_dir/ && cd $tf_dir && \
    git clone --depth 1 --single-branch https://github.com/tensorflow/tensorflow.git -b r1.14

#You have bazel 0.26.1- (@non-git) installed.
#Please downgrade your bazel installation to version 0.25.2 or lower to build TensorFlow!
COPY --from=build-bazel:0.26.1 /home/packages/bazel/output/bazel /usr/local/bin

RUN cd $bdir && ./configure && cp .tf_configure.bazelrc /default.tf_configure.bazelrc
RUN cd $bdir && echo "build --jobs=12" >> .bazelrc

#ERROR: /home/packages/tensorflow/tensorflow/tensorflow/python/BUILD:5919:1: Executing genrule //tensorflow/python:framework/fast_tensor_util.pyx_cython_translation failed (Exit 127)
#/usr/bin/env: 'python': No such file or directory

RUN ln -s /usr/bin/python3 /usr/bin/python

# need to set -flax-vector-conversions for both copt and host_copt
COPY r1.14.tf_configure.bazelrc $bdir/.tf_configure.bazelrc

RUN cd $bdir && bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
RUN cd $bdir && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg

# docker cp build-tf-r1.14:/tensorflow_pkg/tensorflow-1.14.0-cp37-cp37m-linux_aarch64.whl .
