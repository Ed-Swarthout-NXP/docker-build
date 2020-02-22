# Copyright 2019, 2020 NXP
# SPDX-License-Identifier: MIT
#
# Download and build bazel binary
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

ARG BASE_IMAGE=ubuntu:19.04
FROM ${BASE_IMAGE}

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

# Note: Ensure there is a host entry for apt-cacher-ng IP address
COPY 00aptproxy-apt-cacher-ng /etc/apt/apt.conf.d/00aptproxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    openjdk-8-jdk-headless \
    python3 \
    unzip \
    wget \
    zip && \
    rm -rf /var/lib/apt/lists

# Fix:
# Execution platform: @bazel_tools//platforms:host_platform
# /usr/bin/env: 'python': No such file or directory
# Target //src:bazel_nojdk failed to build
RUN ln -s /usr/bin/python3 /usr/bin/python

ARG BAZEL_VERSION=2.1.1

# Must not build bazel from /. Fixes:
# bazel bootstrap ERROR: infinite symlink expansion detected [start of symlink chain] /
WORKDIR /home/packages/bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-${BAZEL_VERSION}-dist.zip && \
    unzip -q bazel-${BAZEL_VERSION}-dist.zip && \
    rm bazel-${BAZEL_VERSION}-dist.zip

RUN env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh
