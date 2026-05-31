#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/skills-install-smoke.XXXXXX")"
trap 'rm -rf "$tmp_root"' EXIT

log() {
  printf '\n[%s] %s\n' "$1" "$2"
}

assert_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    printf 'expected file missing: %s\n' "$path" >&2
    exit 1
  fi
}

test_skillenv_install() {
  log "skillenv" "Installing this repo as a managed source"

  local workdir="$tmp_root/skillenv-project"
  mkdir -p "$workdir"
  cd "$workdir"

  git init -q
  skillenv init
  skillenv add "$repo_root" --name local-skills

  if [[ ! -d .agents/skills ]]; then
    printf 'skillenv did not create .agents/skills\n' >&2
    exit 1
  fi

  local installed
  installed="$(find .agents/skills -path '*/SKILL.md' -print -quit)"
  if [[ -z "$installed" ]]; then
    printf 'skillenv did not install any SKILL.md into .agents/skills\n' >&2
    exit 1
  fi

  assert_file "$installed"
  grep -q '^name: handoff$' "$installed"
}

test_rulesync_install() {
  log "rulesync" "Fetching official skills and generating .agents/skills"

  local workdir="$tmp_root/rulesync-project"
  mkdir -p "$workdir"
  cd "$workdir"

  git init -q
  rulesync init
  rulesync fetch dyoshikawa/rulesync --features skills
  rulesync generate --targets agentsskills --features skills

  if [[ ! -d .agents/skills ]]; then
    printf 'rulesync did not create .agents/skills\n' >&2
    exit 1
  fi

  local installed
  installed="$(find .agents/skills -path '*/SKILL.md' -print -quit)"
  if [[ -z "$installed" ]]; then
    printf 'rulesync did not generate any SKILL.md into .agents/skills\n' >&2
    exit 1
  fi

  assert_file "$installed"
}

test_skills_cli_install() {
  log "skills" "Installing the local handoff skill with the skills CLI"

  local workdir="$tmp_root/skills-cli-project"
  mkdir -p "$workdir"
  cd "$workdir"

  git init -q
  skills add "$repo_root" --skill handoff --agent codex --yes

  local installed
  installed="$(find . -path '*/handoff/SKILL.md' -print -quit)"
  if [[ -z "$installed" ]]; then
    printf 'skills CLI did not install handoff into the temp project\n' >&2
    exit 1
  fi

  assert_file "$installed"
  grep -q '^name: handoff$' "$installed"
}

test_skillenv_install
test_rulesync_install
test_skills_cli_install

log "done" "All install smoke tests passed"
