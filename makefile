# Python virtual environment settings
VENV_NAME=.venv
VENV_ACTIVATE=$(VENV_NAME)/bin/activate
PYTHON=python3

# Docker settings
IMAGE_NAME=ansible-test-env
CONTAINER_NAME=ansible-test-container

# Ansible settings
PRIVATE_KEY_PATH=$PRIVATE_KEY_PATH
ANSIBLE_PORT=2222
PLAYBOOK=main.yml

.PHONY: setup-venv lint build start stop restart delete run-playbook setup clean

setup-venv:
	@test -d $(VENV_NAME) || $(PYTHON) -m venv $(VENV_NAME)
	@. $(VENV_ACTIVATE) && pip install -r requirements.txt

lint:
	@ansible-lint playbooks/*.yml roles/*

build:
	@docker build -t $(IMAGE_NAME) .

start:
	@docker run -d --name $(CONTAINER_NAME) -p 2222:22 $(IMAGE_NAME)

stop:
	@docker stop $(CONTAINER_NAME)

restart:
	@docker restart $(CONTAINER_NAME)

delete:
	@docker rm $(CONTAINER_NAME)

run-playbook:
	@. $(VENV_ACTIVATE) && ansible-playbook -i "localhost," -e "ansible_port=$(ANSIBLE_PORT)" -e "ansible_user=ansibleuser" -e "ansible_ssh_private_key_file=$(PRIVATE_KEY_PATH)" -e "ansible_connection=ssh" $(PLAYBOOK)

setup:
	@make setup-venv
	@make build
	@make start

clean:
	@echo "Cleaning up..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@rm -rf $(VENV_NAME)
	@deactivate
	@echo "Cleaned."
