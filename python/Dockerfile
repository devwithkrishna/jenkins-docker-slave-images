# Using jenkins/inbound-agent:latest-jdk21 as base image
FROM jenkins/inbound-agent:latest-jdk21

# Argument for the base image
ARG PYTHON_VERSION=3.13.5

# Add label
LABEL authors="githubofkrishnadhas"

# Root user
USER root

# Install Docker & basic packages
RUN apt-get update && \
    apt-get install -y -qq \
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
    libnss3-dev 


ENV LANG=C.UTF-8

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

# Install Python 3.13

RUN curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make altinstall && \
    && update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${PYTHON_VERSION} 1 \
    && update-alternatives --install /usr/bin/pip3 pip /usr/local/bin/pip${PYTHON_VERSION} 1 \
    && pip install --no-cache-dir --upgrade pip \
    && pip install poetry pipenv \
    && cd .. \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz \
    && rm -rf Python-${PYTHON_VERSION} \
    && apt-get remove -y --purge build-essential\
    libncursesw5-dev \
    libreadline-dev \
    libssl-dev \
    libsqlite3-dev \
    libffi-dev \
    libbz2-dev \
    zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*

# Set up symlink for bash as sh

RUN ln -sf /bin/bash /bin/sh