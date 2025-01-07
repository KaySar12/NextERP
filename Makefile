.SHELLFLAGS += ${SHELLFLAGS} -e
PWD = $(shell pwd)
UID = $(shell id -u)
GID = $(shell id -g)
PYTHON=python
DOCKERCMD=docker
DOCKER_COMPOSE_CMD=docker-compose
DOCKER_BUILD=$(DOCKERCMD) build
DOCKER_PUSH=$(DOCKERCMD) push
DOCKER_IMAGE=$(DOCKERCMD) image
DEPLOY_PATH=${PWD}/deployment
SETUP_PATH=${PWD}/setup
HASH := $(shell git rev-parse HEAD)
CONFIG=odoo.conf
ODOO_IMAGE=hub.nextzenos.com/nexterp/odoo
CONTAINER_ID=odoo-${TAG}
TAG := main
install:
	sudo apt -y update && \
	sudo apt install -y python3-full python3-pip libldap2-dev libpq-dev libsasl2-dev
run_test_docker: 
	sudo docker exec -it ${CONTAINER_ID} odoo -i all_modules --log-level=test --test-enable -d testdb  --stop-after-init --config=/etc/odoo/${CONFIG} --xmlrpc-port=8070
run_test_local: 
	odoo-bin -i all_modules --log-level=test --test-enable -d testdb  --stop-after-init --config=${CONFIG}
gen_config:
	${PWD}/setup/init_config.sh ${ODOO_IMAGE} ${TAG} ${CONTAINER_ID}
build-image: gen_config
	DOCKER_BUILDKIT=1 ${DOCKER_BUILD} . --progress plain --tag ${ODOO_IMAGE}:${TAG}
push-image:
	$(DOCKER_PUSH) ${ODOO_IMAGE}:${TAG}
run-server-local:
	${PYTHON} odoo-bin --config=${CONFIG}
run-server-docker: 
	@if ! docker ps | grep -q "${CONTAINER_ID}"; then \
		echo "Container not found. Running docker-compose up -d"; \
	else \
		echo "Container already running. Skipping docker-compose up -d."; \
	fi
	cd ${DEPLOY_PATH}  &&\
	${DOCKER_COMPOSE_CMD} up -d
clean_up: 
	@if ! docker ps | grep -q "${CONTAINER_ID}"; then \
		echo "Container not found. Skipping"; \
	else \
		cd ${DEPLOY_PATH}  &&\
		${DOCKER_COMPOSE_CMD} down; \
	fi
	find ${DEPLOY_PATH} -mindepth 1 -maxdepth 1 -type d \
    ! -name "etc" \
	! -name "addons" \
    ! -name "file_to_keep.txt" \
    ! -name "*.log" \
    -exec rm -rf {} +
	
