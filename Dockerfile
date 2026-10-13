FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ARG TORCH_CUDA_ARCH_LIST="6.1;7.5;8.6"
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    FORCE_CUDA=1 \
    TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        wget \
        ffmpeg \
        python3 \
        python3-dev \
        python3-pip \
        python-is-python3 \
        libsm6 \
        libxext6 \
        libgl1 \
        libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/FB-BEV

# Install the matching PyTorch/CUDA wheels into Ubuntu 20.04's Python 3.8.
RUN python3 -m pip install --no-cache-dir --upgrade 'pip<25' \
    && python3 -m pip install --no-cache-dir \
        torch==1.12.0+cu113 \
        torchvision==0.13.0+cu113 \
        --extra-index-url https://download.pytorch.org/whl/cu113 \
    && python3 -m pip install --no-cache-dir \
        --only-binary=:all: \
        mmcv-full==1.6.0 \
        -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.12.0/index.html \
    && python3 -m pip install --no-cache-dir \
        mmdet==2.24.0 \
        mmsegmentation==0.24.0

COPY . /workspace/FB-BEV

RUN python3 -m pip install --no-cache-dir -r requirements/runtime.txt \
    && python3 -m pip install --no-cache-dir --no-deps -e .

CMD ["/bin/bash"]

# docker build -f dockerfile -t fb-bev .
# docker run --gpus all -it --rm fb-bev
# docker run -it -v /path/on/host:/path/in/container IMAGE_NAME
# docker start -ai fb-bev
# docker exec -it fb-bev /bin/bash
