ARG L4T_TAG
FROM nvcr.io/nvidia/l4t-base:${L4T_TAG}

# setup TZ environment
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

#
# Install any utils needed for execution
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# Install nvidia-cuda-dev for CUDA developer packages
# Use nvidia-cuda if need CUDA runtime only
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-cuda-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# Install nvidia-cudnn8-dev for CuDNN developer packages
# Use nvidia-cudnn8 if need CuDNN runtime only
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-cudnn8-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# Install nvidia-tensorrt-dev for TensorRT developer packages
# Use nvidia-tensorrt if need TensorRT runtime only
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-tensorrt-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# Install nvidia-vpi-dev for VPI developer packages
# Use nvidia-vpi if need VPI runtime only
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-vpi-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# Install Multimedia API samples & libs
#
RUN apt-get update && apt-get download nvidia-l4t-jetson-multimedia-api \
    && dpkg-deb -R ./nvidia-l4t-jetson-multimedia-api_*_arm64.deb ./mm-api \
    && cp -r ./mm-api/usr/src/jetson_multimedia_api /usr/src/jetson_multimedia_api \
    && ./mm-api/DEBIAN/postinst \
    && rm -rf ./nvidia-l4t-jetson-multimedia-api_*_arm64.deb ./mm-api

# set Python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# 
# Install OpenCV
# 
ARG OPENCV_VERSION
COPY jetson/scripts/opencv_install_deps.sh /tmp/opencv_install_deps.sh
RUN ./tmp/opencv_install_deps.sh
COPY jetson/scripts/opencv_build.sh /tmp/opencv_build.sh
RUN ./tmp/opencv_build.sh ${OPENCV_VERSION}

#
# Install PyTorch
#
ARG PYTORCH_VERSION
ARG PYTORCH_VERSION_SUFFIX
ARG TORCHVISION_VERSION
ARG TORCHVISION_VERSION_SUFFIX
ARG PYTORCH_DOWNLOAD_URL
COPY jetson/scripts/install_pytorch.sh /tmp/install_pytorch.sh
RUN ./tmp/install_pytorch.sh ${PYTORCH_VERSION} ${PYTORCH_VERSION_SUFFIX} \
    ${TORCHVISION_VERSION} ${TORCHVISION_VERSION_SUFFIX} \
    ${PYTORCH_DOWNLOAD_URL}

#Update libraries
RUN ldconfig 

#
# Setup environment variables
#
ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

RUN pip3 install --no-cache-dir --verbose pycuda six

