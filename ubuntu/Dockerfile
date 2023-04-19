ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:-compute,utility}

RUN apt update && \
    apt install -y \
        wget curl build-essential software-properties-common \
        zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
        libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION
COPY ubuntu/install_opencv.sh /tmp/install_opencv.sh
RUN ./tmp/install_opencv.sh ${OPENCV_VERSION}
