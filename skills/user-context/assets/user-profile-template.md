`.agents/users/${whoami}.md` に置くこと。

## Front Matter

```yaml
---
user_name: ${user_name}   # whoami の出力
role: "..."               # 役割・ペルソナ
disabled_skills: []        # 暗示的な使用を禁止するスキル名
---
```

## 本文セクション（指定された分だけ）

- `## Communication Style` — 回答のトーン・詳しさ・使用言語・専門用語の扱いなど。
- `## Explicit Non-Goals` — 絶対にやらない / 避けてほしいこと。
- `## Custom Preference` — 特定の skill / command / plugin 向けの個人設定。
  - 配下に `### ${type}:${name}` の見出しを作る（例: `### skill:visual-explainer`）。
  - 唯一のルール: 他と被らない unique な見出しにすること。
  - 任意の skill / command / plugin が、自分のセクションを自由に読み書きしてよい。

