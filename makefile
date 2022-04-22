.PHONY: build development production repl clean

include .env

DOCKER_COMPOSE_RUN_OPTIONS=--rm

ifeq (${CI},true)
	DOCKER_COMPOSE_RUN_OPTIONS=--rm --user root -T
endif

build:
	docker-compose build

development: build
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) --service-ports elm reactor --port ${ELM_REACTOR_PORT}

production: build
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) sh rm -rf ${ELM_PRODUCTION_FOLDER} \
		&& docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) elm make --optimize --output=${ELM_PRODUCTION_FOLDER}/${ELM_PRODUCTION_FILE} ${ELM_SOURCES_FOLDER}/${ELM_SOURCES_FILE} \
		&& docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) uglifyjs --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' --output ${ELM_PRODUCTION_FOLDER}/${ELM_PRODUCTION_FILE} ${ELM_PRODUCTION_FOLDER}/${ELM_PRODUCTION_FILE} \
		&& docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) uglifyjs --mangle --output ${ELM_PRODUCTION_FOLDER}/${ELM_PRODUCTION_FILE} ${ELM_PRODUCTION_FOLDER}/${ELM_PRODUCTION_FILE} \
		&& docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) sh cp assets/* ${ELM_PRODUCTION_FOLDER}

repl: build
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) elm repl

clean: build
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) sh bash -c 'for file in $(shell cat .gitignore); do rm -rf .$$file; done'
