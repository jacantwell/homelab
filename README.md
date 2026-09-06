# homelab

Compose stacks that run on `jasperpi`. One directory per stack. The Pi pulls this repo and
runs `compose up` on a timer, so **merging to `main` is deploying**.

```
homelab/
  bin/homelab-sync            git pull + compose up for every stack (idempotent)
  systemd/                    user timer that runs homelab-sync every 5 min
  ledboard/                   LED matrix daemon: compose.yml, .env.example, data/
```

Conventions, per the original `.gitignore`: persistent state lives in `<stack>/data/`, secrets
in `<stack>/.env`. Both are ignored. Every stack ships a `.env.example`.

## First-time setup on the Pi

```sh
cd ~/homelab
git remote add origin https://github.com/jacantwell/homelab.git   # once
git pull origin main
cp ledboard/.env.example ledboard/.env                             # edit if needed
make install-sync                                                  # user systemd timer
```

`make install-sync` needs the user manager to keep running without an SSH session:

```sh
sudo loginctl enable-linger jasper   # once, the only sudo in this repo
```

## Day to day

```sh
make up SVC=ledboard       # compose up one stack
make logs SVC=ledboard     # follow logs
make sync                  # what the timer runs
make status                # timer + container health
```

From a laptop: `ssh jasperpi.local ~/homelab/bin/homelab-sync` deploys right now instead of
waiting for the timer.

## Secrets

`ledboard/.env` on the Pi is not tracked, so new vars in `.env.example` don't arrive on their own.
`LEDBOARD_AUTH_ISSUER` and `LEDBOARD_AUTH_AUTHORIZED_PARTIES` must be set there or `POST /text`
stays open to the LAN.

## Rollback

Set `LEDBOARD_TAG=sha-abc1234` in `ledboard/.env` and run `make sync`. Set it back to `main`
when fixed. Image tags come from [jacantwell/ledboard](https://github.com/jacantwell/ledboard) CI.
