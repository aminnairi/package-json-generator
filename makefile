.PHONY: build development production repl clean install

include .env

DOCKER_COMPOSE_RUN_OPTIONS=--rm

ifeq (${CI},true)
	DOCKER_COMPOSE_RUN_OPTIONS=--rm --user root -T
endif

build:
	docker-compose build

install:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) npm install

development: install
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) --service-ports npm run development

production: install
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) npm run production

repl: install
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) elm repl

clean: build
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) sh bash -c 'for file in $(shell cat .gitignore); do rm -rf .$$file; done'
