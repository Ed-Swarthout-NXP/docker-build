# Build bazel


### make BAZEL_VERSION=2.1.1

Creates docker image to download and build bazel runtime.
Extracts bazel runtime from image

### make BAZEL_VERSION=2.1.1 docker-clean

Removes docker image

### notes

Assumes apt-cacher-ng is used to cache apt packages.
Set APT_CACHER_NG to ip-address of host.

If not available, delete the contents of 00aptproxy-apt-cacher-ng.
