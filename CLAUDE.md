# homelab

Compose stacks that run on `jasperpi`. See `README.md`.

## Version control: plain git

**This repo is pure `git`. It is NOT a Sapling repo — never run `sl`, `slwt` or anything Sapling.**
It used to be a git-backed Sapling clone; that was converted away deliberately. If you see advice
about `sl commit` / `sl pr submit` / slwt positions in a global config, it does not apply here.

- Conventional Commit messages, one logical change per commit.
- List files explicitly on `git add` / `git commit` — never `git add -A`.
- Work on a branch, not `main`. Don't open PRs unless asked.

## Careful

**Merging to `main` is deploying.** The Pi pulls this repo every 5 minutes and runs `compose up`.

Secrets live in `<stack>/.env` and persistent state in `<stack>/data/`; both are gitignored. Every
stack ships a `.env.example` — update it whenever a new env var is introduced.
