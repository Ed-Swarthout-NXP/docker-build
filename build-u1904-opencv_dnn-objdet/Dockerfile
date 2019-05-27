#
# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Build OpenCV 4.1.0 with Python3 for aarch64/x86_64
# Add flask-video-streaming server
# Add imutils for threaded camera reading
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------


# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t u1904-run-opencv_dnn-objdet .
# stages docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65

# docker run -e CAMERA=opencv_dnn_2objdet --rm -it -p 5000:5000 --privileged -v /home/packages/model:/root/model --name 2objdet u1904-run-opencv_dnn-objdet
# docker2run -e CAMERA=opencv_dnn_yolov2 --rm -it -p 5000:5000 --privileged -v /home/packages/model:/root/model --name yolov2 u1904-run-opencv_dnn-objdet
# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

# --- builder ---

FROM ubuntu:19.04 as u1904-python3

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

# Note: Ensure there is a host entry for ubuntu-apt-cacher-ng IP address
COPY 00aptproxy-ubuntu-cacher-ng /etc/apt/apt.conf.d/00aptproxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    file \
    fonts-freefont-ttf \
    git \
    gunicorn3 \
    libgtk-3-0 \
    python3 \
    python3-apt \
    python3-click \
    python3-distutils \
    python3-engineio \
    python3-flask \
    python3-flask-socketio \
    python3-gunicorn \
    python3-itsdangerous \
    python3-markupsafe \
    python3-numpy \
    python3-six \
    python3-socketio-client \
    software-properties-common \
    unzip && \
    rm -rf /var/apt/lists

# --------------- opencv: build debian package --------------------
FROM u1904-python3 as u1904-opencv_dnn-builder-4.1.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    debhelper \
    libgtk-3-dev \
    pkg-config \
    protobuf-compiler \
    python3-dev \
    python3-protobuf

ENV opencv_dir=/home/packages/opencv opencv_ver=4.1.0
ENV bdir=$opencv_dir/build

RUN mkdir -p $opencv_dir/ && cd $opencv_dir && \
    git clone --depth 1 https://github.com/opencv/opencv.git -b $opencv_ver

# Configure to just build Debian packages and not tarballs
RUN mkdir -p $bdir && cd $bdir && \
    cmake ../opencv -DBUILD_PERF_TESTS=OFF \
	  -DWITH_ADE:BOOL=OFF -DBUILD_opencv_python2:BOOL=OFF \
          -DCPACK_BINARY_DEB=ON -DCPACK_BINARY_STGZ=OFF -DCPACK_BINARY_TZ=OFF -DCPACK_BINARY_TGZ=OFF -DOPENCV_GENERATE_PKGCONFIG=YES

# /usr/bin/file is needed to fix:
# CMake Error at /usr/share/cmake-3.10/Modules/CPackDeb.cmake:622 (message):
#  CPackDeb: file utility is not available.  CPACK_DEBIAN_PACKAGE_SHLIBDEPS
#  and CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS options are not available.

RUN cd $bdir && make -j16 && make install && make package && tar -cf /opencv_dnn-4.1.0.deb.tar *.deb

# build imutils

RUN mkdir -p /home/packages/imutils && cd /home/packages/imutils && \
    git clone --depth 1 https://github.com/Ed-Swarthout-NXP/imutils.git -b debian_package && \
    cd imutils && \
    dpkg-buildpackage -uc -b

# --- runtime image ---

FROM u1904-python3 as u1904-run-opencv_dnn-base

COPY --from=u1904-opencv_dnn-builder-4.1.0 /opencv_dnn-4.1.0.deb.tar /opencv/opencv_dnn.deb.tar
RUN cd /opencv && tar -xf opencv_dnn.deb.tar && \
    dpkg -i \
    OpenCV-4.1.0-*-libs.deb \
    OpenCV-4.1.0-*-licenses.deb \
    OpenCV-4.1.0-*-python.deb && \
    rm -rf /opencv

# Install imutils
COPY --from=u1904-opencv_dnn-builder-4.1.0 /home/packages/imutils/python3-imutils_0.5.2-1ed1_all.deb /
RUN cd / && dpkg -i python3-imutils_0.5.2-1ed1_all.deb && rm -f /python3-imutils*deb

ENV CAMERA_SOURCE=0
ENV CAMERA_PORT=5000
EXPOSE $CAMERA_PORT

# edgescale requires a command on invocation, so provide run.sh in root
COPY run.sh /

ENV CAMERA=opencv_dnn_2objdet

FROM u1904-run-opencv_dnn-base as u1904-run-opencv_dnn-objdet

RUN cd /root && \
    git clone --depth 1 https://github.com/Ed-Swarthout-NXP/flask-video-streaming.git -b NXP-opencv_dnn

WORKDIR "/root/flask-video-streaming"

CMD gunicorn3 --threads 5 --workers 1 --bind 0.0.0.0:$CAMERA_PORT app:app
