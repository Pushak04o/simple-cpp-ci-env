FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    ninja-build \
    cmake \
    ccache \
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

# Aliases
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-22 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-22 100 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-16 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-16 100

ARG DEFAULT_COMPILER=clang

# Choose default compiler
RUN if [ "$DEFAULT_COMPILER" = "gcc" ]; then \
        update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-16 100 \
        && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-16 100; \
    else \
        update-alternatives --install /usr/bin/cc cc /usr/bin/clang-22 100 \
        && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-22 100; \
    fi
WORKDIR /workspace

