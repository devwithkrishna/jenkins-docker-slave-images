#!/bin/bash

# Function to extract Docker version
extract_docker_version() {
    local file="docker-version.txt"
    if [[ -f "$file" ]]; then
        local DOCKER_VERSION=$(grep -i 'docker version' "$file" | awk '{print $3}')
        echo "DOCKER_VERSION=$DOCKER_VERSION" >> "$GITHUB_ENV"
        echo "Set DOCKER_VERSION=$DOCKER_VERSION in GitHub environment"
    else
        echo "File $file does not exist."
    fi
}

# Function to extract Azure CLI version
extract_azure_cli_version() {
    local file="az-version.txt"
    if [[ -f "$file" ]]; then
        local AZ_CLI_VERSION=$(awk '/azure-cli/ {print $2}' "$file")
        echo "AZ_CLI_VERSION=$AZ_CLI_VERSION" >> "$GITHUB_ENV"
        echo "Set AZ_CLI_VERSION=$AZ_CLI_VERSION in GitHub environment"
    else
        echo "File $file does not exist."
    fi
}

# Function to extract Terraform version
extract_terraform_version() {
    local file="terraform-version.txt"
    if [[ -f "$file" ]]; then
        local TERRAFORM_VERSION=$(terraform --version | grep -o 'Terraform v[0-9.]*' | awk '{print $2}')
        echo "TERRAFORM_VERSION=$TERRAFORM_VERSION" >> "$GITHUB_ENV"
        echo "Set TERRAFORM_VERSION=$TERRAFORM_VERSION in GitHub environment"
    else
        echo "File $file does not exist."
    fi
}

terraform --version >> terraform-version.txt

az --version >> az-version.txt

docker --version >> docker-version.txt


# Check for the existence of the files and execute corresponding functions
if [[ -f "docker-version.txt" ]]; then
    extract_docker_version
fi

if [[ -f "terraform-version.txt" ]]; then
    extract_terraform_version
fi

if [[ -f "az-version.txt" ]]; then
    extract_azure_cli_version
fi
