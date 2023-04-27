PYTORCH_VERSION=$1
PYTORCH_VERSION_SUFFIX=$2
TORCHVISION_VERSION=$3
TORCHVISION_VERSION_SUFFIX=$4
PYTORCH_DOWNLOAD_URL=$5

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

wget -O torch_$PYTORCH_VERSION.whl $PYTORCH_DOWNLOAD_URL && \
pip3 install torch_$PYTORCH_VERSION.whl && \
rm torch_$PYTORCH_VERSION.whl

TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2;8.7"
apt-get update && \
apt-get install -y --no-install-recommends \
        git \
        build-essential \
        libjpeg-dev \
        zlib1g-dev \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

git clone https://github.com/pytorch/vision torchvision && \
cd torchvision && \
git checkout $TORCHVISION_VERSION && \
python3 setup.py install && \
cd ../ && \
rm -rf torchvision