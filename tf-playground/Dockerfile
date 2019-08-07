#
# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Build Neural Network Playground web server from tensorflow github
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.8.42 -t tf-playground .

# Run with:
# docker run --rm -d -p 8080:8080 --name tf-playground tf-playground

FROM node:lts-slim as tf-playground

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

COPY 00aptproxy-ubuntu-cacher-ng /etc/apt/apt.conf.d/00aptproxy
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  unzip && \
  rm -f /etc/apt/apt.conf.d/00aptproxy

# RUN git clone --depth 1 https://github.com/tensorflow/playground
# use zip to avoid installing git
ADD https://github.com/tensorflow/playground/archive/master.zip /

RUN unzip master.zip && \
  rm -f master.zip

WORKDIR "playground-master"
RUN npm install && \
    npm run build

CMD npm run serve
