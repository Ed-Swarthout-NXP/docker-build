# NXP arm64/x86 Display v4l2-ctl output
#
# Ed.swarthout@nxp.com
#
#--------------------------------------------------

# Build with:

# docker build --add-host=ubuntu-apt-cacher-ng:192.168.1.65 -t edswarthoutnxp/opencv4-v4l2-ctl .

# Run with

# docker run --rm -it --device=/dev/video0 --name v4l2-ctl edswarthoutnxp/opencv4-v4l2-ctl

# --------------- build image

FROM edswarthoutnxp/opencv4-flask as opencv4-v4l2-ctl

RUN apt-get update && apt-get install -y v4l-utils kmod

RUN echo 'lsmod | sort; v4l2-ctl --all' > /cmd.sh && chmod +x /cmd.sh

CMD /cmd.sh

