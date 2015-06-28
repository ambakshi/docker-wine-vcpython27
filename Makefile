.PHONY: all run ssh build xeyes

GH_USER?=
ifeq ($(DOCKER_HOST),)
HOST?=localhost
else
HOST:=$(shell echo $(DOCKER_HOST) | sed -Ee 's@^[tu]cp://(.*)+[:][0-9]*@\1@g' )
endif


all: run ssh

insecure.key:
	ssh-keygen -q -f insecure.key -N ""

run:
	@test -n "$(GH_USER)" || { echo >&2 "Specify github username via GH_USER=foo"; exit 2; }
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	docker rm -f wine || true
	docker run -v /tmp/wine:/tmp/wine:ro -d -P -e GH_USER=$(GH_USER) --name wine --hostname winehq.local wine
	@sleep 2

ssh:
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	PORT=`docker inspect -f '{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' wine` && \
      ssh -Y -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $$PORT dev@$(HOST)

xeyes:
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	@PORT=`docker inspect -f '{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' wine` && \
      ssh -Y -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $$PORT dev@$(HOST) xeyes

build:
	docker build -t wine .

vs2013.7z:
	cd ISOs && cmd.exe /c download_and_extract.bat `cygpath -wa ..\\$@`

