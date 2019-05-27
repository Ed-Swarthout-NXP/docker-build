# Copyright 2019 NXP
# SPDX-License-Identifier: MIT
#
# Ed.Swarthout@NXP.com
#
# build docker which runs the opencv_dnn wiki example
#
#
# See wiki [Deep-Learning-in-OpenCV](https://github.com/opencv/opencv/wiki/Deep-Learning-in-OpenCV)
#
# Uses camera_opencv_dnn_wiki.py:  Adapts [TensorFlow-Object-Detection-API](https://github.com/opencv/opencv/wiki/TensorFlow-Object-Detection-API)
#
# To use, set CAMERA=opencv_dnn_wiki and place the tensorflow model in ../model.
#
# Requires ../model/frozen_inference_graph.pb and ../model/graph.pbtxt
#
#--------------------------------------------------


# Build with:
# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t edswarthoutnxp/u1904-run-opencv_dnn-wiki .

# docker run -e CAMERA=opencv_dnn_wiki --rm -it -p 5000:5000 --privileged -v /home/packages/model/2object_detect:/root/model --name dnn_wiki edswarthoutnxp/u1904-run-opencv_dnn-wiki

# echo 192.168.1.65 ubuntu-apt-cacher-ng >> /etc/hosts

FROM u1904-run-opencv_dnn-base as u1904-run-opencv_dnn-wiki

RUN cd /root && \
    git clone --depth 1 https://github.com/Ed-Swarthout-NXP/flask-video-streaming.git -b opencv_dnn_wiki

WORKDIR "/root/flask-video-streaming"

CMD gunicorn3 --threads 5 --workers 1 --bind 0.0.0.0:$CAMERA_PORT app:app

ENV CAMERA=opencv_dnn_wiki

