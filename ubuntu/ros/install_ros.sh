#!/bin/bash

ROS_DISTRO=$1
ROS_ROOT=$2
ROS_PKG=$3

echo "ROS distro: $ROS_DISTRO"
echo "ROS root: $ROS_ROOT"

# 
# add the ROS deb repo to the apt sources list
#
apt-get update && \
apt-get install -y --no-install-recommends \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

apt-get update && \
apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libbullet-dev \
    libpython3-dev \
    python3-colcon-common-extensions \
    python3-flake8 \
    python3-pip \
    python3-numpy \
    python3-pytest-cov \
    python3-rosdep \
    python3-setuptools \
    python3-vcstool \
    python3-rosinstall-generator \
    libasio-dev \
    libtinyxml2-dev \
    libcunit1-dev \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# install some pip packages needed for testing
python3 -m pip install -U \
    argcomplete \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest

apt-get update && \
apt-get install -y --no-install-recommends \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        yaml-cpp \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# 
# download/build ROS from source
#
mkdir -p $ROS_ROOT/src && \
cd $ROS_ROOT && \

# https://answers.ros.org/question/325245/minimal-ros2-installation/?answer=325249#post-id-325249
rosinstall_generator --deps --rosdistro $ROS_DISTRO $ROS_PKG \
    launch_xml \
    launch_yaml \
    launch_testing \
    launch_testing_ament_cmake \
    demo_nodes_cpp \
    demo_nodes_py \
    example_interfaces \
    camera_calibration_parsers \
    camera_info_manager \
    cv_bridge \
    v4l2_camera \
    vision_opencv \
    vision_msgs \
    image_geometry \
    image_pipeline \
    image_transport \
    compressed_image_transport \
    compressed_depth_image_transport \
    rosbridgesuite \
    > ros2.$ROS_DISTRO.$ROS_PKG.rosinstall && \
cat ros2.$ROS_DISTRO.$ROS_PKG.rosinstall && \
vcs import src < ros2.$ROS_DISTRO.$ROS_PKG.rosinstall && \

# https://github.com/dusty-nv/jetson-containers/issues/181
rm -r $ROS_ROOT/src/ament_cmake && \
git -C $ROS_ROOT/src/ clone https://github.com/ament/ament_cmake -b $ROS_DISTRO && \

# install dependencies using rosdep
apt-get update && \
cd $ROS_ROOT && \
rosdep init && \
rosdep update && \
rosdep install -y \
    --ignore-src \
    --from-paths src \
    --rosdistro $ROS_DISTRO \
    --skip-keys "libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
rm -rf /var/lib/apt/lists/* && \
apt-get clean && \

# build it!
colcon build \
    --merge-install \
    --cmake-args -DCMAKE_BUILD_TYPE=Release && \

# remove build files
rm -rf $ROS_ROOT/src && \
rm -rf $ROS_ROOT/logs && \
rm -rf $ROS_ROOT/build && \
rm $ROS_ROOT/*.rosinstall