# Ansible Test Env with Docker Integration

This project sets up a development environment for Ansible playbooks, using Docker containers as target hosts. It includes a Makefile for easy management of the environment and playbooks for testing Ansible configurations.

## Prerequisites

- Docker
- Python 3
- SSH Key (for SSH key-based authentication with the Docker containers)
- M1 Pro (local env I used, YMMV)

## Quick Start

```bash
vim .env.template  # Fill this out with your own vars if different
source .env.template  # Source .env file
cp /Users/$USER/.ssh/$KEY_FILENAME.pub files/  # Put your pub file in files/
vim dockerfile  # replace `files/id_ed25519.pub` with yours if different
make setup  # Setup env
make run-playbook  # Run playbook against Docker hosts
```

## Setting Up the Environment

### Virtual Environment

The project uses a Python virtual environment to manage Python dependencies including Ansible and ansible-lint.

To set up and activate the virtual environment:

```bash
make setup-venv
```

This command creates a virtual environment and installs the necessary dependencies from `requirements.txt`.

### Docker Containers

Docker is used to create isolated containers that mimic target hosts for Ansible.

To build the Docker image and start the containers:

```bash
make build
make start
```

This command builds a Docker image with SSH enabled and starts three containers based on this image.

## Using the Makefile

The Makefile includes the following commands:

- **setup-venv**: Build the python virtual environment.
- **build**: Build the Docker image for the containers.
- **start**: Start the Docker containers.
- **stop**: Stop the Docker containers.
- **restart**: Restart the Docker containers.
- **delete**: Remove the Docker containers.
- **setup**: Setup the venv and docker.
- **run-playbook**: Run the Ansible playbook against the containers.
- **lint**: Lint the Ansible playbooks and roles.
- **clean**: Clean up the environment by stopping and removing containers and deleting the virtual environment.

### Example Commands

- To start the environment:
  
  ```bash
  make start
  ```

- To run the Ansible playbook:

  ```bash
  make run-playbook
  ```

- To lint your Ansible playbooks and roles:

  ```bash
  make lint
  ```

- To clean up the environment:

  ```bash
  make clean
  ```

## Ansible Inventory and Playbooks

- The Ansible inventory is defined in the `inventory` `hosts` file, with the group and host variables organized in the `group_vars` and `host_vars` subdirectories.
- The main playbook is located at `playbooks/main.yml`.
- Custom roles can be found in the `roles` directory.
