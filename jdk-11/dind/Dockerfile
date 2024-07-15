# Using jenkins/inbound-agent:latest-jdk11 as base image
FROM jenkins/inbound-agent:latest-jdk11

# Add label
LABEL authors="githubofkrishnadhas"

# Root user
USER root

# Install basic packages
RUN apt-get update -q && \
    apt-get install -y -qq \
    ca-certificates \
    curl \
    wget \
    zip \
    apt-transport-https \
    lsb-release \
    gnupg \
    software-properties-common \

# Install Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Get Docker version
RUN docker --version >> docker-version.txt

# Install azure cli latest avaialble version
RUN apt-get update -y && \
    mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install azure-cli -y

# Get Azure cli version
RUN az --version >> az-version.txt









