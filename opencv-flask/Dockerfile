# NXP arm64/x86 OpenCV flask video server
#
# Ed.swarthout@nxp.com
#
#--------------------------------------------------

# Build with:

# docker build -t edswarthoutnxp/opencv4-flask .

# Run with (four examples):

# docker run --rm -it -e CAMERA_PORT=5000 -p 5000:5000 --device=/dev/video0 --name opencv4-flask edswarthoutnxp/opencv4-flask
# d      run --rm -it -e CAMERA_PORT=5001 -p 5001:5001 --device=/dev/video1 -e CAMERA_SOURCE=1 --name opencv4-flask1 edswarthoutnxp/opencv4-flask
# d      run --rm -it -e CAMERA_PORT=5002 -p 5002:5002 -e CAMERA_SOURCE='rtsp://root:pass@axis-9e2d/axis-media/media.amp' --add-host=axis-9e2d:192.168.2.98 --name opencv4-flask2 edswarthoutnxp/opencv4-flask
# d      run --rm -it -e CAMERA_PORT=5003 -p 5003:5003 -e CAMERA_SOURCE='rtsp://brazos:brazos@brazosfhd:554/axis-media/media.amp?videocodec=h264' --name opencv4-flask3 edswarthoutnxp/opencv4-flask

# --------------- build image

FROM opencv-4.0.1 as opencv4-flask

RUN cd /root && git clone --depth=1 https://github.com/Ed-Swarthout-NXP/flask-video-streaming.git

WORKDIR "/root/flask-video-streaming"
ENV CAMERA=opencv
ENV CAMERA_PORT=5000
EXPOSE $CAMERA_PORT

CMD gunicorn --threads 5 --workers 1 --bind 0.0.0.0:$CAMERA_PORT app:app
#CMD ["gunicorn", "--threads", "5", "--workers", "1", "--bind", "0.0.0.0:$CAMERA_PORT", "app:app"]
