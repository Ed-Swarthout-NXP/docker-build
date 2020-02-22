# Copyright 2019, 2020 NXP
# SPDX-License-Identifier: MIT

# make BAZEL_VERSION=2.1.1

BAZEL_VERSION ?= 2.1.1
BASE_IMAGE ?= ubuntu:19.04

TAG_IMAGE := $(subst :,_,build-bazel-$(BASE_IMAGE)):$(BAZEL_VERSION)

# Host IP address of apt-cacher-ng proxy
APT_CACHER_NG ?= 192.168.1.65

all: docker-extract

docker-build:
	docker build -t $(TAG_IMAGE) --add-host=apt-cacher-ng:$(APT_CACHER_NG) --build-arg BAZEL_VERSION=$(BAZEL_VERSION) --build-arg BASE_IMAGE=$(BASE_IMAGE) .

docker-run: docker-build
	docker run --rm -it --name build-bazel --add-host=apt-cacher-ng:$(APT_CACHER_NG) $(TAG_IMAGE) bash

docker-extract: docker-build
	docker run --rm -d --name build-bazel $(TAG_IMAGE) sleep 1h && \
	docker cp build-bazel:/home/packages/bazel/output/bazel bazel-$(subst :,_,$(BASE_IMAGE))-$(BAZEL_VERSION) && \
	docker kill build-bazel

docker-clean:
	docker rmi $(TAG_IMAGE)
