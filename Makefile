.SHELLFLAGS += ${SHELLFLAGS} -e
PWD = $(shell pwd)
UID = $(shell id -u)
GID = $(shell id -g)
PYTHON=python
DOCKERCMD=docker
DOCKER_BUILD=$(DOCKERCMD) build
DOCKER_PUSH=$(DOCKERCMD) push
DOCKER_IMAGE=$(DOCKERCMD) image
DEPLOY_PATH=${PWD}/deployment
SETUP_PATH=${PWD}/setup
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
HASH := $(shell git rev-parse HEAD)
CONFIG=odoo.conf
install:
	pyenv virtualenv ${BRANCH}
	pyenv activate ${BRANCH}
	export DEBIAN_FRONTEND=noninteractive && \
	sudo apt -y update && \
	sudo apt install -y python3-full python3-pip libldap2-dev libpq-dev libsasl2-dev && \
	pip install -r requirements.txt
gen_test_config:
	${PWD}/setup/init_conf.sh
run_test: 
	${PYTHON} odoo-bin -i all_modules --log-level=test --test-enable -d testdb  --stop-after-init --config=${CONFIG}
clean_test:
	${PWD}/setup/clean_up.sh
gen_env:
	${PWD}/setup/init_env.sh
build-image: gen_env
	DOCKER_BUILDKIT=1 ${DOCKER_BUILD} . --progress plain --tag ${ODOO_IMAGE}
push-image:
	$(DOCKERPUSH) ${ODOO_IMAGE}
run-server:
	${PYTHON} odoo-bin --config=${CONFIG}
