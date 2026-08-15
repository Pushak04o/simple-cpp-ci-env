FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    ninja-build \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# GCC 16
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-16 g++-16 && \
    rm -rf /var/lib/apt/lists/*

# Clang 22
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 22 && \
    rm llvm.sh && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y ccache && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace


