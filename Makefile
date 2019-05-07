.PHONY : build _dockerfile publish clean clean_image run join start stop root

# IMAGE SETTINGS
IMAGE=workspace
VERS='latest'
DATE=$(shell date +%y%m%d)
NAME=$(IMAGE)

# USER SETTINGS
USER=$(shell whoami)
UID=$(shell id -u)
GID=$(shell id -g)
HOMEDIR=$(HOME)

build: clean clean_image _dockerfile

_dockerfile:
	docker build \
		--build-arg user=${USER} \
		--build-arg uid=${UID} --build-arg gid=${GID} \
		--pull -t $(IMAGE):$(VERS) .

clean:
	docker container rm "$(NAME)" || :

clean_image:
	docker image rm -f $(IMAGE):$(VERS) || :

run:
	nohup docker run \
		--name "$(NAME)" \
		-v $(HOMEDIR):/home/$(USER) \
		--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
		--restart unless-stopped \
		--network host \
		--hostname $(NAME) \
		--tty \
		$(IMAGE):$(VERS) &>/dev/null &

join:
	docker exec -it "$(NAME)" /bin/bash

start:
	docker start -ia "$(NAME)"

stop:
	docker stop "$(NAME)"

root:
	# docker run -u root --name "$(NAME)" -v $(HOMEDIR):/home/$(USER) -it $(IMAGE):$(VERS)
	docker exec -u root -it "$(NAME)" /bin/bash
