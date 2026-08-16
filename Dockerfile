FROM ubuntu:24.04
ARG DEFAULT_COMPILER=clang

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        wget \
        curl \
        git \
        ninja-build \
        cmake \
        ccache \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN if [ "$DEFAULT_COMPILER" = "gcc" ]; then \
        add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
        apt-get update && \
        apt-get install -y --no-install-recommends gcc-16 g++-16 && \
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-16 100 && \
        update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-16 100 && \
        update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-16 100 && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-16 100; \
    else \
        wget -q https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh && \
        chmod +x /tmp/llvm.sh && \
        /tmp/llvm.sh 22 all && \
        rm /tmp/llvm.sh && \
        update-alternatives --install /usr/bin/clang clang /usr/bin/clang-22 100 && \
        update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-22 100 && \
        update-alternatives --install /usr/bin/cc cc /usr/bin/clang-22 100 && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-22 100; \
    fi \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
