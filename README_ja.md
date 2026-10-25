# igtm/skills

[English README](./README.md)

個人用の agent skills リポジトリです。

この repo は flat な `skills/<skill-name>/` レイアウトです。`npx skills` でそのまま扱いやすく、`skillenv` も `skillenv.toml` の source として取り込めます。

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

skills を使いたいプロジェクト側で初期化します:

```bash
cd /path/to/your/project
skillenv init
```

生成された `skillenv.toml` を編集して、この repo とプロジェクト内の `.agents/skills` への配置を宣言します:

```toml
[skills]
"github:igtm/skills" = ["*"]

[[deploy]]
target = "agents:repo"
include = ["*"]
```

宣言した skills を取得し、配置します:

```bash
skillenv fetch
skillenv link
```

`skillenv` 1.x は manifest と lock file を使います。旧 `add` / `update` コマンドと `skillenv/default` レイアウトは、`skillenv.toml`、`fetch`、`link` に置き換わっています。

GitHub 経由ではなくローカル checkout を使う場合は、`[skills]` の GitHub エントリを次に置き換えます:

```toml
[skills]
"path:/path/to/skills" = ["*"]
```

`[[deploy]]` の設定は残し、再度 `skillenv fetch` と `skillenv link` を実行します。

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

`skillenv.toml` の同じ `[skills]` テーブルにエントリを追加します:

```toml
[skills]
"github:igtm/skills" = ["*"]
"github:vercel-labs/agent-skills" = ["*"]
```

上記の `[[deploy]]` 設定を残し、`skillenv fetch` と `skillenv link` を実行します。

必要な skill だけ入れる場合は、その source の `["*"]` を名前の配列に置き換えます:

```toml
"github:vercel-labs/agent-skills" = ["frontend-design", "skill-creator"]
```

upstream の変更を確認し、manifest 内の remote source を更新する場合:

```bash
skillenv outdated
skillenv fetch --update
skillenv link
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
