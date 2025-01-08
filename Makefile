DOCKER_PATH = ./srcs/docker-compose.yaml

all: build up_detach

build: 
	@echo "[*] Building images ..."
	mkdir -p $(HOME)/data/database
	mkdir -p $(HOME)/data/files
	@docker-compose -f $(DOCKER_PATH) build

up:
	@echo "[+] Creating containers ..."
	@docker-compose -f $(DOCKER_PATH) up

up_detach:
	@echo "[+] Creating containers in detached mode ..."
	@docker-compose -f $(DOCKER_PATH) up -d

down:
	@echo "[-] Stopping and deleting containers ..."
	@docker-compose -f $(DOCKER_PATH) down -v

stop:
	@echo "[!] Stopping containers ..."
	@docker-compose -f $(DOCKER_PATH) stop

remove_images:
	@echo "[!] Deleting images ..."
	@if [ -n "$$(docker image ls -aq)" ]; then \
		docker image rm -f $$(docker image ls -q); \
	else \
		echo "No images to remove."; \
	fi

remove_containers:
	@echo "[!] Deleting containers ..."
	@if [ -n "$$(docker container ls -aq)" ]; then \
		docker container rm -f $$(docker container ls -aq); \
	else \
		echo "No containers to remove."; \
	fi

remove_volumes:
	@echo "[!] Deleting volumes ..."
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm -f $$(docker volume ls -q); \
	else \
		echo "No volumes to remove."; \
	fi

remove_networks:
	@echo "[!] Deleting networks ..."
	@if [ -n "$$(docker network ls --filter name=inception -q)" ]; then \
		docker network rm -f inception; \
	else \
		echo "Inception network doesn't exists"; \
	fi

fclean: remove_containers remove_images remove_volumes remove_networks

re: fclean build up_detach

.PHONY:  build up up_detach down stop remove_images remove_containers remove_volumes remove_networks fclean re
