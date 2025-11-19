DOCKER_COMPOSE_BIN = docker-compose
DOCKER_COMPOSE = $(DOCKER_COMPOSE_BIN)

GO_BIN = go
GO = $(GO_BIN)

APP = docker exec -ti $$(docker-compose ps -q app)

all: start

download:
	@$(GO) mod download

vendor:
	@$(GO) mod vendor -v

build: download vendor
	@$(DOCKER_COMPOSE) build

start: build
	@$(DOCKER_COMPOSE) up -d app

restart: stop start

reload: stop
	docker-compose down --remove-orphans
	docker network prune -f
	@$(DOCKER_COMPOSE) up --no-recreate -d app

stop:
	@$(DOCKER_COMPOSE) stop app || true

kill:
	@$(DOCKER_COMPOSE) kill || true

rm: stop
	@$(DOCKER_COMPOSE) rm --force app || true

# Bash in app container
app-bash-console:
	$(APP) bash
