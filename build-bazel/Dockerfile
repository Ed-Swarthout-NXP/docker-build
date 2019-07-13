#
# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Build bazel binary
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t build-bazel:0.26.1 .
# stages docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65

# docker run --rm -it --name build-bazel build-bazel

FROM ubuntu:19.04 as build-bazel

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

# Note: Ensure there is a host entry for ubuntu-apt-cacher-ng IP address
COPY 00aptproxy-ubuntu-cacher-ng /etc/apt/apt.conf.d/00aptproxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    openjdk-8-jdk-headless \
    python3 \
    unzip \
    wget \
    zip

ARG bazel_ver=0.26.1

# Must not build bazel from /. Fixes:
# bazel bootstrap ERROR: infinite symlink expansion detected [start of symlink chain] /
ENV bazel_dir=/home/packages/bazel
RUN mkdir -p $bazel_dir/ && cd $bazel_dir && \
    wget https://github.com/bazelbuild/bazel/releases/download/$bazel_ver/bazel-${bazel_ver}-dist.zip && \
    unzip -q bazel-${bazel_ver}-dist.zip

# Fix:
# Execution platform: @bazel_tools//platforms:host_platform
# /usr/bin/env: 'python': No such file or directory
# Target //src:bazel_nojdk failed to build
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN cd $bazel_dir; env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh
