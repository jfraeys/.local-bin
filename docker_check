#!/bin/bash

# Function to start Docker if not running
start_docker() {
    echo "Docker is not running. Starting Docker..."
    open --background -a Docker
    sleep 3  # Wait for Docker to start
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    read -p "Do you want to install Docker using Homebrew? (y/n): " choice
    if [ "$choice" == "y" ]; then
        brew install --cask docker
        echo "Docker has been installed. Please restart this script."
        exit 0
    else
        echo "Docker is required to run this script. Exiting."
        exit 1
    fi
fi

# Check if Docker is running
if [ "$(docker info >/dev/null 2>&1 && echo "running")" != "running" ]; then
    start_docker
fi

# Check if docker-compose is called
if [ "$1" == "docker-compose" ]; then
    # If docker-compose is called, check if Docker is running again
    if [ "$(docker info >/dev/null 2>&1 && echo "running")" != "running" ]; then
        start_docker
    fi
fi

# Run the provided command
"$@"

