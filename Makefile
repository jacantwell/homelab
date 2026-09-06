.PHONY: up down logs sync status install-sync

SVC ?= ledboard

up:
	docker compose -f $(SVC)/compose.yml up -d --pull always --remove-orphans

down:
	docker compose -f $(SVC)/compose.yml down

logs:
	docker compose -f $(SVC)/compose.yml logs -f --tail=100

sync:
	./bin/homelab-sync

status:
	systemctl --user status homelab-sync.timer --no-pager || true
	docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'

install-sync:
	mkdir -p ~/.config/systemd/user
	cp systemd/homelab-sync.service systemd/homelab-sync.timer ~/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user enable --now homelab-sync.timer
	systemctl --user list-timers homelab-sync.timer --no-pager
