include deployment/.env
.SHELLFLAGS += ${SHELLFLAGS} -e
PWD = $(shell pwd)
UID = $(shell id -u)
GID = $(shell id -g)
PYTHON=/root/.pyenv/shims/python
DOCKERCMD=docker
DOCKER_BUILD=$(DOCKERCMD) build
DOCKER_PUSH=$(DOCKERCMD) push
DOCKER_IMAGE=$(DOCKERCMD) image
DEPLOY_PATH=${PWD}/deployment
update_env:
    @awk '/^MY_VAR=/ { $$0 = "MY_VAR=new_value" } 1' .env > .env.tmp && mv .env.tmp .env
build-image: 
	DOCKER_BUILDKIT=1 ${DOCKER_BUILD} . --progress plain --tag ${ODOO_IMAGE}
push-image:
	$(DOCKERPUSH) ${ODOO_IMAGE}
run-server:
	${PYTHON} odoo-bin
