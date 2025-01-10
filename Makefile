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
CONFIG=odoo.conf
ODOO_IMAGE=hub.nextzenos.com/nexterp/odoo
TAG := $(shell rev-parse --abbrev-ref HEAD)
CONTAINER_ID=odoo-${TAG}
install:
	sudo apt -y update && \
	sudo apt install -y build-essential python3-full python3-pip libldap2-dev libpq-dev libsasl2-dev
run_test_docker: 
	sudo docker exec ${CONTAINER_ID} odoo --test-tags :TestAccountMove.test_out_invoice_auto_post_monthly,TestAccountMove.test_included_tax  --log-level=test --test-enable -d testdb --stop-after-init --config=/etc/odoo/${CONFIG} --xmlrpc-port=8071 && \
	sudo docker exec ${CONTAINER_ID} odoo db --config=/etc/odoo/${CONFIG} drop testdb 
run_test_local: 
	odoo-bin -i all_modules --log-level=test --test-enable -d testdb  --stop-after-init --config=${CONFIG}
gen_config:
	${PWD}/setup/init_config.sh ${ODOO_IMAGE} ${TAG} ${CONTAINER_ID}
build_image:
	DOCKER_BUILDKIT=1 ${DOCKER_BUILD} . --progress plain --tag ${ODOO_IMAGE}:${TAG}
push_image:
	$(DOCKER_PUSH) ${ODOO_IMAGE}:${TAG}
run_server_local:
	${PYTHON} odoo-bin --config=${CONFIG}
run_server_docker: 
	@if ! docker ps | grep -q "${CONTAINER_ID}"; then \
		echo "Container not found. Running docker-compose up -d"; \
	else \
		echo "Container already running. Skipping docker-compose up -d."; \
	fi
	cd ${DEPLOY_PATH}  &&\
	${DOCKER_COMPOSE_CMD} up -d
update_tag:
	${SETUP_PATH}/update_tag.sh $(CURR_BRANCH)
restore_database:
	@echo "Checking for backup.zip in container..."
	@if sudo docker exec ${CONTAINER_ID} test -f /etc/odoo/backup/backup.zip; then \
		echo "Restoring database from backup..."; \
		sudo docker exec ${CONTAINER_ID} odoo db --config=/etc/odoo/${CONFIG} load backup /etc/odoo/backup/backup.zip; \
	else \
		echo "Error: backup.zip not found in container. Aborting restore."; \
	fi

stop_server_docker:
	@if ! docker ps | grep -q "${CONTAINER_ID}"; then \
		echo "Container not found. Skipping"; \
	else \
		cd ${DEPLOY_PATH}  &&\
		${DOCKER_COMPOSE_CMD} down; \
	fi
clean_up: 
	@if ! docker ps | grep -q "${CONTAINER_ID}"; then \
		echo "Container not found. Skipping"; \
	else \
		cd ${DEPLOY_PATH}  &&\
		${DOCKER_COMPOSE_CMD} down; \
	fi
	find "${DEPLOY_PATH}" -mindepth 1 -maxdepth 1  \
		! -name "etc" \
		! -name "addons" \
		! -name "backup" \
		! -name "*.sh" \
		! -name "*.template" \
		! -name "*.py" \
		! -name "*.yml" \
		-print0 | sudo xargs -0 rm -rf {} && \
	sudo rm -rf ${DEPLOY_PATH}/etc/*
	
	
