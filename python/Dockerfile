# Base image
FROM jenkins/inbound-agent:latest-jdk21

# Argument for Python version
ARG PYTHON_VERSION=3.13.5

# Metadata
LABEL authors="githubofkrishnadhas"

# Switch to root
USER root

#  Install base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        zip \
        apt-transport-https \
        lsb-release \
        gnupg \
        git \
        software-properties-common \
        libncursesw5-dev \
        libreadline-dev \
        libssl-dev \
        libsqlite3-dev \
        libffi-dev \
        make \
        xz-utils \
        libbz2-dev \
        zlib1g-dev \
        build-essential \
        libnss3-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Azure CLI latest available version
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | \
    tee /etc/apt/sources.list.d/azure-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y -qq azure-cli

# Install Microsoft ODBC Driver 18 Debian 12 package

RUN curl -sSL -O https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
    &&  dpkg -i packages-microsoft-prod.deb \
    &&  rm -rf /var/lib/apt/lists/* \
    &&  rm -rf /var/cache/apt/archives/* \
    && rm packages-microsoft-prod.deb \
    &&  apt-get update && apt-get upgrade -y \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev

# Build & install Python, clean up build deps
RUN curl -fsSL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -o python.tgz && \
    tar -xzf python.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j"$(nproc)" && \
    make altinstall && \
    cd .. && \
    update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${PYTHON_VERSION%.*} 1 && \
    update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip${PYTHON_VERSION%.*} 1 && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir poetry pipenv && \
    # Clean up
    apt-get purge -y \
        build-essential \
        libncursesw5-dev \
        libreadline-dev \
        libssl-dev \
        libsqlite3-dev \
        libffi-dev \
        libbz2-dev \
        zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* python.tgz Python-${PYTHON_VERSION}

# Environment
ENV LANG=C.UTF-8

# Optional: Bash as sh
RUN ln -sf /bin/bash /bin/sh
