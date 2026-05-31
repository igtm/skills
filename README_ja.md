# igtm/skills

[English README](./README.md)

個人用の agent skills リポジトリです。

この repo は flat な `skills/<skill-name>/` レイアウトです。`npx skills` でそのまま扱いやすく、`skillenv` も managed source として flat `skills/<skill>` repo を受け付けるので、そのまま追加できます。

## `mise` で installer 群を管理する

この repo には [mise.toml](./mise.toml) があり、導入フローで使う 3 つの CLI を管理します:

- `skillenv`
- `rulesync`
- `skills`

インストール:

```bash
mise install
```

CI と同じ install smoke test を実行:

```bash
mise run install-smoke
```

GitHub Actions でも push、pull request、manual dispatch ごとにこの smoke test を自動実行します。

## 推奨: `igtm/skillenv` でインストールする

このマシン上の `skillenv` ローカル checkout からインストール:

```bash
cd ~/tmp/skillenv
cargo install --path . --locked
```

そのうえで、skills を使いたいプロジェクト側でこの repo を追加します:

```bash
cd /path/to/your/project
skillenv init
skillenv add igtm/skills --name igtm-skills
skillenv link
```

`skillenv` の repo-local source 自体は `skillenv/default` などの構成ですが、managed remote source はこの repo のような flat `skills/<skill>` 構成でも取り込めます。

GitHub 経由ではなく、この repo のローカル checkout を直接使うこともできます:

```bash
cd /path/to/your/project
skillenv init
skillenv add /path/to/skills --name igtm-skills-local
skillenv link
```

`skillenv` のローカル checkout がない場合は GitHub からインストールします:

```bash
cargo install --git https://github.com/igtm/skillenv.git --locked
```

## `rulesync` でインストールする

`rulesync` は、AI tool の設定と skills を `.rulesync/` 配下でまとめて管理したいときに向いています。

`rulesync` 自体のインストール:

```bash
npm install -g rulesync
# or
brew install rulesync
# or
curl -fsSL https://github.com/dyoshikawa/rulesync/releases/latest/download/install.sh | bash
```

プロジェクトを初期化して、`rulesync` 公式 skills を取得する流れ:

```bash
cd /path/to/your/project
rulesync init
rulesync fetch dyoshikawa/rulesync --features skills
rulesync generate --targets "*" --features "*"
```

この repo 自体を skills source としてそのまま使いたいだけなら、`skillenv` か `npx skills` の方がシンプルです。`.rulesync/` を source of truth にして各 tool 向け設定もまとめて生成したい場合に `rulesync` が向いています。

## `vercel-labs/agent-skills` も同じ方法で入れる

同じ `skillenv` フローで追加できます:

```bash
cd /path/to/your/project
skillenv init
skillenv add vercel-labs/agent-skills --name vercel
skillenv link
```

必要な skill だけ入れる場合:

```bash
skillenv add vercel-labs/agent-skills --skill frontend-design --skill skill-creator --name vercel
```

あとから更新する場合:

```bash
skillenv update vercel
```

## `npx skills` でインストールする

`vercel-labs/agent-skills` は Vercel の `skills` CLI でそのまま入れられます:

```bash
npx skills add vercel-labs/agent-skills
npx skills add vercel-labs/agent-skills --skill frontend-design
npx skills add https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines
```

この repo は flat な `skills/` レイアウトなので、skill ディレクトリを直接指定して入れられます:

```bash
npx skills add https://github.com/igtm/skills/tree/main/skills/<skill-name>
```

## 手動インストール: clone + symlink

まず clone:

```bash
git clone git@github.com:igtm/skills.git
cd skills
```

必要な skill を agent の skill directory に symlink します:

```bash
mkdir -p ~/.codex/skills ~/.claude/skills
ln -s "$(pwd)/skills/<skill-name>" ~/.codex/skills/<skill-name>
ln -s "$(pwd)/skills/<skill-name>" ~/.claude/skills/<skill-name>
```

symlink を使いたくない環境では、ディレクトリをコピーしてください。

## リポジトリ構成

```text
skills/
  <skill-name>/
    SKILL.md
    assets/
    references/
    scripts/
```

- `skills/` がこの repo の公開用 skill 置き場です。
- 各 skill directory は self-contained にします。
- `assets/` `references/` `scripts/` は必要なときだけ置きます。

## 新しい skill を追加する

ディレクトリを作って、その中に `SKILL.md` を置きます:

```bash
mkdir -p skills/my-skill
$EDITOR skills/my-skill/SKILL.md
```

最小例:

```md
---
name: my-skill
description: One-line description of what this skill does.
---

# my-skill

Put the instructions here.
```

## 参考

- `igtm/skillenv`: <https://github.com/igtm/skillenv>
- `dyoshikawa/rulesync`: <https://github.com/dyoshikawa/rulesync>
- `vercel-labs/agent-skills`: <https://github.com/vercel-labs/agent-skills>
- `vercel-labs/skills` install docs: <https://github.com/vercel-labs/skills/blob/main/README.md>
