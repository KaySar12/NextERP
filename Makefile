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
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
HASH := $(shell git rev-parse HEAD)
update_env:
	@awk '/^ODOO_TAG=/ { $$0 = "ODOO_TAG=${BRANCH}" } 1' ${DEPLOY_PATH}/.env > ${DEPLOY_PATH}/.env.tmp && mv ${DEPLOY_PATH}/.env.tmp ${DEPLOY_PATH}/.env
build-image: update_tag
	DOCKER_BUILDKIT=1 ${DOCKER_BUILD} . --progress plain --tag ${ODOO_IMAGE}
push-image:
	$(DOCKERPUSH) ${ODOO_IMAGE}
run-server:
	${PYTHON} odoo-bin
