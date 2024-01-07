# Python virtual environment settings
VENV_NAME=.venv
VENV_ACTIVATE=$(VENV_NAME)/bin/activate
PYTHON=python3

# Docker settings
IMAGE_NAME=ansible-test-env
CONTAINER_NAME=ansible-test-container
CONTAINERS=$(CONTAINER_NAME)-1 $(CONTAINER_NAME)-2 $(CONTAINER_NAME)-3

# Ansible settings
PRIVATE_KEY_PATH=$PRIVATE_KEY_PATH
ANSIBLE_PORT=2222
PLAYBOOK=playbooks/main.yml

.PHONY: setup-venv lint build start stop restart delete run-playbook setup clean

setup-venv:
	@test -d $(VENV_NAME) || $(PYTHON) -m venv $(VENV_NAME)
	@. $(VENV_ACTIVATE) && pip install -r requirements.txt

lint:
	@ansible-lint playbooks/* roles/*

build:
	@docker build -t $(IMAGE_NAME) .

start:
	@for i in 1 2 3; do \
		docker run -d --name $(CONTAINER_NAME)-$$i -p 222$$i:22 $(IMAGE_NAME); \
	done

stop:
	@for container in $(CONTAINERS); do \
		docker stop $$container; \
	done

restart:
	@for container in $(CONTAINERS); do \
		docker restart $$container; \
	done

delete:
	@for container in $(CONTAINERS); do \
		docker rm $$container; \
	done

run-playbook:
	@. $(VENV_ACTIVATE) && ansible-playbook -i inventory/hosts $(PLAYBOOK)

setup:
	@make setup-venv
	@make build
	@make start

clean:
	@echo "Cleaning up..."
	@make stop 2>/dev/null || true
	@make delete 2>/dev/null || true
	@rm -rf $(VENV_NAME) 2>/dev/null || true
	@echo "Cleaned."
