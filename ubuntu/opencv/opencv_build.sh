#!/bin/bash

OPENCV_VERSION=$1
echo "Opencv Version $OPENCV_VERSION"

# install dependencies
apt install -y ---no-install-recommends \
    libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libglew-dev \
    libgtk2.0-dev libgtk-3-dev libcanberra-gtk* \
    libxvidcore-dev libx264-dev \
    libtbb2 libtbb-dev libdc1394-22-dev libxine2-dev \
    libv4l-dev v4l-utils qv4l2 \
    gstreamer1.0-tools libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
    libavresample-dev libvorbis-dev libtesseract-dev \
    libfaac-dev libmp3lame-dev libtheora-dev libpostproc-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libopenblas-dev libatlas-base-dev libblas-dev \
    liblapack-dev liblapacke-dev libeigen3-dev gfortran \
    libhdf5-dev protobuf-compiler \
    libprotobuf-dev libgoogle-glog-dev libgflags-dev \
    unzip 

# Download opencv and opencv_contrib source
cd /tmp
# git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git
# git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git
wget -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
unzip opencv.zip && unzip opencv_contrib.zip
rm opencv.zip opencv_contrib.zip
mv opencv-$OPENCV_VERSION opencv && mv opencv_contrib-$OPENCV_VERSION opencv_contrib

mkdir -p /tmp/build
cd /tmp/build

# run cmake
cmake \
    -D CPACK_BINARY_DEB=ON \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D BUILD_opencv_java=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D CUDA_ARCH_BIN=$CUDA_ARCH_BIN \
    -D CUDA_ARCH_PTX= \
    -D CUDA_FAST_MATH=ON \
    -D CUDNN_INCLUDE_DIR=/usr/include \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D WITH_EIGEN=ON \
    -D ENABLE_NEON=OFF \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_OPENGL=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_GTK=ON \
    -D WITH_IPP=OFF \
    -D WITH_TBB=ON \
    -D BUILD_TIFF=ON \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_TESTS=OFF \
    ../opencv

# build
make -j$(nproc)
make install
rm -r /tmp/opencv && rm -r /tmp/opencv_contrib
rm -r /tmp/build
