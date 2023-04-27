#!/bin/bash
PYTORCH_VERSION=$1
PYTORCH_VERSION_SUFFIX=$2
TORCHVISION_VERSION=$3
TORCHVISION_VERSION_SUFFIX=$4
PYTORCH_DOWNLOAD_URL=$5
PYTHON_VERSION=$6

echo "pytorch installation"
echo "torch: $PYTORCH_VERSION, torchvision: $TORCHVISION_VERSION, python: $PYTHON_VERSION"
echo "torch wheel url: $PYTORCH_DOWNLOAD_URL"
echo "torch suffix: $PYTORCH_VERSION_SUFFIX, torchvision suffix: $TORCHVISION_VERSION_SUFFIX"

apt-get update && \
apt-get install -y --no-install-recommends \
        python3-pip \
        python3-dev \
        libopenblas-dev \
        libopenmpi-dev \
        openmpi-bin \
        openmpi-common \
        gfortran \
        libomp-dev \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

pip3 install --no-cache-dir setuptools Cython wheel
pip3 install --no-cache-dir --verbose numpy

PY=${PYTHON_VERSION//"."/""}
TORCH_WHEEL=torch-$PYTORCH_VERSION-cp$PY-cp$PY-linux_aarch64.whl

wget -O $TORCH_WHEEL $PYTORCH_DOWNLOAD_URL && \
pip3 install $TORCH_WHEEL && rm $TORCH_WHEEL &7 \
pip3 install --no-cache-dir torchvision==$TORCHVISION_VERSION

