#!/bin/bash
# Copyright 2019 NXP

# MIT

cd /root/flask-video-streaming
#export CAMERA_PORT=5000
#export CAMERA=opencv_dnn_object_detect
exec /usr/bin/gunicorn3 --threads 5 --workers 1 --bind 0.0.0.0:$CAMERA_PORT app:app
