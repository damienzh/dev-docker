#!/bin/bash

OPENCV_VERSION=$2

# install dependencies
sudo apt-get install -y libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev libpng-dev libtiff-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libglew-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev libcanberra-gtk*
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libtbb2 libtbb-dev libdc1394-22-dev libxine2-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2
sudo apt-get install -y gstreamer1.0-tools libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev
sudo apt-get install -y libavresample-dev libvorbis-dev libtesseract-dev
sudo apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev libpostproc-dev
sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get install -y libopenblas-dev libatlas-base-dev libblas-dev
sudo apt-get install -y liblapack-dev liblapacke-dev libeigen3-dev gfortran
sudo apt-get install -y libhdf5-dev protobuf-compiler
sudo apt-get install -y libprotobuf-dev libgoogle-glog-dev libgflags-dev

# Download opencv and opencv_contrib source
git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git
git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git
cd opencv
mkdir build
cd build

# run cmake
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
-D WITH_CUDA=ON \
-D OPENCV_DNN_CUDA=ON \
-D CUDA_FAST_MATH=ON \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D OPENCV_ENABLE_NONFREE=ON \
../

# build
make
sudo make install
