.PHONY: all run ssh build xeyes

GH_USER?=
HOST?=

all: run ssh

run:
	@test -n "$(GH_USER)" || { echo >&2 "Specify github username via GH_USER=foo"; exit 2; }
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	docker rm -f wine
	docker run -d -p 2222:22 -e GH_USER=$(GH_USER) --name wine --hostname winehq.local wine
	@sleep 2
	docker logs wine

ssh:
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	ssh -Y -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 dev@$(HOST)

xeyes:
	@test -n "$(HOST)" || { echo >&2 "Specify docker host via HOST=foo"; exit 2; }
	ssh -Y -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 dev@$(HOST) xeyes

build:
	docker build -t wine .
