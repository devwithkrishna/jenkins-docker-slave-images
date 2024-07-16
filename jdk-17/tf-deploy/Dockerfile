# Jenkins inbound agent as base image
FROM jenkins/inbound-agent:latest-jdk17

# Root user for installations
USER root

# update and upgrade system packages
RUN apt-get update -y && apt-get upgrade -y

# install basic packages
 RUN apt-get install -y git openssh-server ca-certificates curl apt-transport-https lsb-release gnupg wget software-properties-common

# Install terraform - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -y && apt-get install terraform -y && terraform --version


# install azure cli latest avaialble version - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
RUN apt-get update -y && \
    mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install azure-cli -y
