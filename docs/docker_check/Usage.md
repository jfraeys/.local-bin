## [docker_check](../../scripts/docker_check)

This script automates the process of ensuring Docker is installed and running before executing Docker-related commands. If Docker is not installed, it provides an option to install it via Homebrew.

## Usage

Run the script without any arguments to automatically check if Docker is installed and running. If Docker is not installed, it prompts to install it via Homebrew. If Docker is not running, it starts Docker.

```bash
./docker_check.sh
```

You can also specify a command as an argument to execute Docker-related commands. If the provided command is docker-compose, the script ensures Docker is running before executing `docker-compose`.

```bash
./docker_check.sh [command]
```

Example Usage

Automatically check if Docker is installed and running:

```bash
./docker_check.sh
```

Execute a Docker command:

```bash
./docker_check.sh docker run hello-world
```

Execute a Docker Compose command:

```bash
./docker_check.sh docker-compose up -d
```
The script checks whether Docker is installed and running. If Docker is not installed, it provides an option to install it via Homebrew. If Docker is not running, it starts Docker. If the docker-compose command is provided, the script checks Docker's status again before executing the command.

