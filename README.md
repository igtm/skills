# igtm/skills

[日本語 README](./README_ja.md)

Personal agent skills repository.

This repo uses a flat `skills/<skill-name>/` layout. That makes it work naturally with `npx skills`, and `skillenv` can also consume it as a managed source because it accepts flat `skills/<skill>` repositories.

## Manage the installers with `mise`

This repo includes [mise.toml](./mise.toml) to manage the three CLIs used in the install flows:

- `skillenv`
- `rulesync`
- `skills`

Install them:

```bash
mise install
```

Run the same install smoke tests used in CI:

```bash
mise run install-smoke
```

GitHub Actions runs the smoke test automatically on push, pull request, and manual dispatch.

## Recommended: install with `igtm/skillenv`

Install `skillenv` from the local checkout on this machine:

```bash
cd ~/tmp/skillenv
cargo install --path . --locked
```

Then add this repo to any project where you want the skills:

```bash
cd /path/to/your/project
skillenv init
skillenv add igtm/skills --name igtm-skills
skillenv link
```

`skillenv` repo-local sources use `skillenv/default` and related directories, but managed remote sources can be flat `skills/<skill>` repos like this one.

If you want to use a local checkout of this repo instead of GitHub:

```bash
cd /path/to/your/project
skillenv init
skillenv add /path/to/skills --name igtm-skills-local
skillenv link
```

If you do not have the local checkout of `skillenv`, install it from GitHub instead:

```bash
cargo install --git https://github.com/igtm/skillenv.git --locked
```

## Install with `rulesync`

`rulesync` is useful when you want to manage AI tool configuration and skills from a unified `.rulesync/` source of truth.

Install `rulesync`:

```bash
npm install -g rulesync
# or
brew install rulesync
# or
curl -fsSL https://github.com/dyoshikawa/rulesync/releases/latest/download/install.sh | bash
```

Initialize a project and fetch the official `rulesync` skills:

```bash
cd /path/to/your/project
rulesync init
rulesync fetch dyoshikawa/rulesync --features skills
rulesync generate --targets "*" --features "*"
```

If your goal is to consume this repository directly as a skills source, `skillenv` or `npx skills` is usually simpler. `rulesync` is the better fit when you also want to generate tool configs from `.rulesync/`.

## Also install `vercel-labs/agent-skills`

With the same `skillenv` workflow:

```bash
cd /path/to/your/project
skillenv init
skillenv add vercel-labs/agent-skills --name vercel
skillenv link
```

Install only selected skills from that pack:

```bash
skillenv add vercel-labs/agent-skills --skill frontend-design --skill skill-creator --name vercel
```

Update the managed source later:

```bash
skillenv update vercel
```

## Install with `npx skills`

`vercel-labs/agent-skills` supports direct installation with Vercel's `skills` CLI:

```bash
npx skills add vercel-labs/agent-skills
npx skills add vercel-labs/agent-skills --skill frontend-design
npx skills add https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines
```

This repo uses a flat `skills/` layout, so you can install a specific skill directly by folder path:

```bash
npx skills add https://github.com/igtm/skills/tree/main/skills/<skill-name>
```

## Manual install by clone + symlink

Clone the repo:

```bash
git clone git@github.com:igtm/skills.git
cd skills
```

Then symlink the skill you want into your agent's skill directory:

```bash
mkdir -p ~/.codex/skills ~/.claude/skills
ln -s "$(pwd)/skills/<skill-name>" ~/.codex/skills/<skill-name>
ln -s "$(pwd)/skills/<skill-name>" ~/.claude/skills/<skill-name>
```

If symlinks are not suitable in your environment, copy the directory instead.

## Repository layout

```text
skills/
  <skill-name>/
    SKILL.md
    assets/
    references/
    scripts/
```

- `skills/` is the published, shared skill set for this repo.
- Each skill folder is self-contained.
- Optional `assets/`, `references/`, and `scripts/` are added only when needed.

## Creating a new skill

Create a directory and put a `SKILL.md` inside it:

```bash
mkdir -p skills/my-skill
$EDITOR skills/my-skill/SKILL.md
```

Minimal example:

```md
---
name: my-skill
description: One-line description of what this skill does.
---

# my-skill

Put the instructions here.
```

## References

- `igtm/skillenv`: <https://github.com/igtm/skillenv>
- `dyoshikawa/rulesync`: <https://github.com/dyoshikawa/rulesync>
- `vercel-labs/agent-skills`: <https://github.com/vercel-labs/agent-skills>
- `vercel-labs/skills` install docs: <https://github.com/vercel-labs/skills/blob/main/README.md>
