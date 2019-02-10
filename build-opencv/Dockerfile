#
# Build OpenCV 4.0.1 with Python3 for aarch64
#
# Ed.Swarthout@NXP.com
#
#--------------------------------------------------

# Build with:

# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t edswarthoutnxp/opencv-4.0.1 .
# stages docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65

FROM ubuntu:18.04 as ubuntu-python3

LABEL maintainer="Ed Swarthout <ed.swarthout@nxp.com>"

# Note: Ensure there is a host entry for ubuntu-apt-cacher-ng IP address
COPY 00aptproxy-ubuntu-cacher-ng /etc/apt/apt.conf.d/00aptproxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    curl \
    file \
    git \
    libatlas3-base \
    libfreetype6-dev \
    libhdf5-dev \
    liblapack3 \
    libpng-dev \
    libzmq5-dev \
    pkg-config \
    protobuf-compiler \
    python3 \
    python3-dev \
    rsync \
    software-properties-common \
    unzip

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \    
    rm get-pip.py

# do not allow tabs in this list
RUN python3 -m pip install -U \
    Flask-SocketIO \
    Pillow \
    gunicorn \
    h5py \
    ipykernel \
    jupyter \
    matplotlib \
    mock \
    numpy==1.16.1 \
    paho-mqtt \
    protobuf==3.6.1 \
    setuptools>=40.8.0 \
    termcolor \
    werkzeug

# pandas needs numpy to already be installed
RUN python3 -m pip install -U \
    pandas

# OpenCV runtime libraries
RUN apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    gstreamer1.0-x gstreamer1.0-plugins-base \
    fonts-freefont-ttf \
    libaacs0 libavcodec57 libavformat57 libavresample3 libavutil55 \
    libilmbase12 libdc1394-22 libgphoto2-6 libswscale4 libopenexr22

# --------------- opencv: build debian package --------------------
FROM ubuntu-python3 as opencv-builder-4.0.1

ARG DEBIAN_FRONTEND=noninteractive
# OpenCV buildtime libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake git \
    libgtk-3-dev \
    libavcodec-dev libavformat-dev libavresample-dev libavutil-dev \
    libgstreamer-gl1.0-0 libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-bad1.0-dev libgstreamer-plugins-base1.0-0 libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-0 libgstreamer-plugins-good1.0-dev libgstreamer1.0-0 libgstreamer1.0-dev \
    liblapack3 \
    libatlas3-base

ENV opencv_dir=/home/packages/opencv arch=aarch64 opencv_ver=4.0.1
ENV bdir=$opencv_dir/$arch

RUN mkdir -p $opencv_dir/ && cd $opencv_dir && \
    git clone --depth 1 https://github.com/opencv/opencv.git -b $opencv_ver

# Configure to just build Debian packages and not tarballs
RUN mkdir -p $bdir && cd $bdir && \
    cmake ../opencv -DBUILD_PERF_TESTS=OFF -DCPACK_BINARY_DEB=ON -DCPACK_BINARY_STGZ=OFF -DCPACK_BINARY_TZ=OFF -DCPACK_BINARY_TGZ=OFF
RUN cd $bdir && make -j16
RUN cd $bdir && make install

# /usr/bin/file is needed to fix:
# CMake Error at /usr/share/cmake-3.10/Modules/CPackDeb.cmake:622 (message):
#  CPackDeb: file utility is not available.  CPACK_DEBIAN_PACKAGE_SHLIBDEPS
#  and CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS options are not available.

RUN cd $bdir && make package
RUN cd $bdir && tar -cf /opencv-4.0.1.deb.tar *.deb

# --------------- opencv: install debian packages --------------------
FROM ubuntu-python3 as opencv-4.0.1-withcache

COPY --from=opencv-builder-4.0.1 /opencv-4.0.1.deb.tar /opencv/opencv.deb.tar
RUN cd /opencv && tar -xf opencv.deb.tar && dpkg -i *.deb && rm -rf /opencv

RUN python3 -m pip install -U python-socketio gevent dnspython greenlet

# --------------- cleanup --------------------
FROM opencv-4.0.1-withcache as opencv-4.0.1

RUN rm -rf /root/.cache && rm -f /etc/apt/apt.conf.d/00aptproxy
