ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:-compute,utility}

# setup TZ environment
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
# RUN ln -snf /user/share/zoneinfo/$TZ /ect/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install -y \
        wget curl build-essential software-properties-common \
        zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
        libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION
COPY ubuntu/opencv/opencv_install_deps.sh /tmp/opencv_install_deps.sh
RUN ./tmp/opencv_install_deps.sh
COPY ubuntu/opencv/opencv_build.sh /tmp/opencv_build.sh
RUN ./tmp/opencv_build.sh ${OPENCV_VERSION}
RUN apt clean && \ rm -rf /var/lib/apt/lists/*
