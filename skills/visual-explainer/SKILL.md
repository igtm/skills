---
name: visual-explainer
description: plan mode で中規模以上の複雑な実装計画を立てるとき、または plan mode でなくても不具合調査タスクや PoC タスクなどまとまった説明をした方が良いときに呼び出す。計画をブラウザで開ける1枚のリッチHTML（図は canvas で手描き）として可視化する。
---

# Visual Explainer

## 1. 概要

このスキルは、考案した実行計画やアーキテクチャ設計を、ブラウザで閲覧可能な1枚のリッチなHTMLファイルとして可視化する。

- 使用技術: Tailwind CSS（CDN） + HTML5 Canvas（JS で図を手描き。**外部の図ライブラリは使わず、指示がなければ図は canvas で描く**）
- ユーザーの見た目の好みは `user-context` スキルが管理する。本スキルは `user-context` から渡された設定を厳格に適用する（好みの仕様・保存方法は本スキルに書かない）。
- 設定が存在しない場合は、サンプルの計画書を生成してユーザーに提示し、視覚的に好みをヒアリングする。

## 2. 前提条件

このスキルを実行する前に、**必ず `user-context` スキルが完了し、現在の実行ユーザーのプロファイルがロードされている必要がある**。ユーザーの好みとその保存先（プロファイルの場所・記法・優先順位）は `user-context` が管理するため、本スキルはそれを参照する。

`user-context` が完了していない場合は、まず `user-context` を実行してからこのスキルに戻る。

## 3. 実行ワークフロー

### Step 1: ユーザー設定の検証とサンプル提示（ヒアリングフェーズ）

1. `user-context` が読み込んだユーザーの見た目設定（テーマ色、アクセントカラー、レイアウトの好みなど）を確認する。
2. 設定が不足している、または空の場合:
   - 汎用的なダミーの実行計画（例: 「APIサーバーの構築フロー」）を、canvas図と補足説明を含む本格的なサンプルとして生成する。
   - 後述の Step 3〜4 の手順に従い、サンプルのHTMLファイルを保存してブラウザで起動する。
   - ブラウザ起動後、ユーザーに以下のように尋ねる:
     > 「サンプルの計画書をブラウザで開きました。配色の好み（ダーク/ライト、特定の色など）や、補足説明の見せ方（例: グリッドカード、シンプルなリストなど）について、ご希望を教えてください。」
   - ユーザーからの回答を受け取り、好みを把握した上で Step 2 へ進む。
   - **把握した好みは `user-context` の手順に従って記録する**（保存先・記法は `user-context` を参照。本スキルや本文に直接ベタ書きしない）。

### Step 2: 計画の構造化とHTMLの生成

1. ユーザーからの本来の要求（例：「認証基盤の移行計画を図解して」）を解析し、ステップと依存関係を抽出する。
2. 適用された設定（または Step 1 でヒアリングした好み）に基づき、計画内容を **canvas（HTML5 Canvas + JS）でノード矩形と矢印を手描き**して図解する（外部図ライブラリは使わない）。
3. canvas のノード配色（type ごとの塗り/枠線）や、図の周辺のUI（Tailwind CSS）を好みに合わせてカスタマイズし、1枚の独立したHTMLを生成する。
   - 詳細は後述の「ベースHTMLテンプレート」を参照。

### Step 3: 出力パスの決定とファイルの保存

1. **同じ計画を更新するときは、新規ファイルを作らず、既存の plan HTML をそのまま修正して作り直す（同一ファイルを上書き）**。別の計画のときだけ新規ファイルを作る。
2. 現在の作業ディレクトリ名、または Git リポジトリ名から `${project_name}` を取得する。
3. ファイル名は日時ではなく、内容が分かる **`{yyyymmdd}_{slug}`** 形式にする（`slug` は計画内容を表す短い英小文字ケバブ名）。
   - 保存先パスのフォーマット: `/tmp/agents_plans/${project_name}/{yyyymmdd}_{slug}.html`
   - 同じ計画を再可視化するときは `slug` を変えず、**同じファイルを上書き**すること。

### Step 4: プレビューの自動起動

ファイルの保存完了後、ローカルマシンの標準コマンドを使用して、ブラウザで生成したプレビューを自動的に立ち上げる。

- macOS: `open <保存したファイルのフルパス>`
- Linux: `xdg-open <保存したファイルのフルパス>`
- Windows: `start <保存したファイルのフルパス>`

## 4. 見た目設定の適用ルール

ユーザーの見た目設定（取得元・記法・優先順位は `user-context` が管理）を以下のように HTML へ反映する。**`user-context` 由来の設定が最優先**であり、下表のデフォルトはその設定が無い項目のフォールバックとして使う。

| 設定項目 | 適用先 |
|---|---|
| テーマ（ダーク/ライト） | `<body>` の背景色・文字色、canvas の背景/ノード/線の配色 |
| アクセントカラー | ヘッダーの下線、canvas ノードの枠線/塗り、リンク、強調要素 |
| UI形状（シャープ/ラウンド） | カードやコンテナの `rounded-*` クラス |
| 補足説明の配置（カード/リスト等） | ステップ詳細のレイアウト（`grid` / `flex flex-col` / エディトリアル単段 など） |

### デフォルト値

`user-context` 由来の設定が無い場合のデフォルト:

- テーマ: ダーク (`bg-slate-900 text-slate-100`)
- アクセントカラー: `#00ffcc`
- UI形状: シャープ (`rounded-none`)
- 補足説明: グリッドカード (`grid grid-cols-1 md:grid-cols-2 gap-4`)

## 5. ベースHTMLテンプレート

出力時は以下の構造を維持し、`<!-- DYNAMIC: ... -->`（HTML 位置）および `/* DYNAMIC: ... */`（JS 位置）の部分を**必ず実値に置換**すること（未置換のまま出力すると配色や描画が壊れる）。これは**最小の骨組み**であり、ユーザー設定が追加要素（例: 右サイド固定目次、エディトリアル単段レイアウト、プルクオート等）を要求する場合は、Tailwind / JS でスロットを足して実装する。

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI Execution Plan - <!-- DYNAMIC: plan_title --></title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: { extend: { colors: { brand: '<!-- DYNAMIC: accent_color -->' } } }
    }
  </script>
</head>
<body class="min-h-screen p-8 font-sans <!-- DYNAMIC: theme_classes -->">
  <div class="max-w-4xl mx-auto">
    <header class="mb-8 pb-4 border-b border-opacity-30 border-current">
      <h1 class="text-3xl font-bold mb-2"><!-- DYNAMIC: plan_title --></h1>
      <p class="text-sm opacity-70">
        Project: <!-- DYNAMIC: project_name --> | Generated at: <!-- DYNAMIC: generated_at -->
      </p>
    </header>

    <div class="mb-8 overflow-x-auto">
      <canvas id="flow" role="img" aria-label="<!-- DYNAMIC: diagram_alt_text -->"></canvas>
    </div>

    <div class="<!-- DYNAMIC: details_layout_classes -->">
      <!-- DYNAMIC: step_detail_cards -->
    </div>
  </div>

  <!-- 図は canvas で手描き（外部の図ライブラリなし） -->
  <script>
    (function () {
      const canvas = document.getElementById('flow');
      const ctx = canvas.getContext('2d');
      const DPR = window.devicePixelRatio || 1;
      // JS 位置のプレースホルダは必ず数値へ置換する（既定値も入れておく）
      const W = /* DYNAMIC: 図の論理幅 */ 800, H = /* DYNAMIC: 図の論理高 */ 600;
      canvas.style.width = W + 'px'; canvas.style.height = H + 'px';
      canvas.width = Math.round(W * DPR); canvas.height = Math.round(H * DPR);
      ctx.scale(DPR, DPR); // Retina 等で高精細化

      // 背景はテーマ色で塗る（canvas はデフォルト透過のため）
      ctx.fillStyle = '#0f172a'; /* DYNAMIC: 背景色（テーマに合わせて置換） */
      ctx.fillRect(0, 0, W, H);

      // ノード定義（x,y=中心）。type ごとに見た目設定の配色を割り当てる
      const N = { /* DYNAMIC: node_definitions */ };

      // drawNode(n): 角はシャープ(rounded-none)な矩形 + 枠線 + 中央テキスト（日本語はゴシック体）
      // arrow(p1, p2, label): 直線 + 矢じり + 背景付きラベル（線の上でも可読）
      // 下→上などの戻り矢印は elbow（直角）経路で重なりを避ける
      // テキスト色はコントラストを確保（背景に対して WCAG AA 目安）
      /* DYNAMIC: draw_calls */
    })();
  </script>
</body>
</html>
```

### 動的置換項目の詳細

| プレースホルダ | 内容 |
|---|---|
| `plan_title` | 計画のタイトル。例: 「認証基盤移行計画」 |
| `project_name` | 現在のプロジェクト名 |
| `generated_at` | 生成日時。例: `2026-06-19 14:30:00` |
| `accent_color` | Tailwind用ブランドカラー。例: `#00ffcc` |
| `theme_classes` | テーマに応じた body クラス。例: `bg-slate-900 text-slate-100` |
| `背景色` | canvas を塗るテーマ背景色（例: `#0f172a`） |
| `node_definitions` / `draw_calls` | canvas に描くノード定義と描画呼び出し（JS） |
| `図の論理幅` / `図の論理高` | canvas の論理サイズ（px。内容に応じて算出） |
| `diagram_alt_text` | 図の代替テキスト（アクセシビリティ用） |
| `details_layout_classes` | 詳細セクションのTailwindレイアウトクラス |
| `step_detail_cards` | 各ステップの説明カードまたはリスト要素 |

## 6. 出力フォーマット制約

- **外部依存の制限**: HTMLにはCDN経由の Tailwind CSS のみを含め（図は canvas で自前描画し、外部の図ライブラリは読み込まない）、ローカルのCSS/JSファイルには依存させないこと。
- **プレースホルダの完全置換**: `<!-- DYNAMIC: ... -->`（HTML）と `/* DYNAMIC: ... */`（JS）は必ず実値に置換する。特に `<script>` 内では `<!-- ... -->` を使わない（JS では行コメント扱いになり値が消える）。
- **動的レイアウトの適応**: ユーザー設定で「カード形式にして」「ステップごとに枠線で囲って」「右サイド目次を付けて」などの要望があれば、Tailwind / JS のクラス・スロットを駆使して柔軟にレイアウトを追加・変更すること。
- **単一ファイル**: すべてのスタイルとスクリプトを1枚のHTMLファイルに内包すること。

## 7. サンプル計画書（ヒアリング用）

`user-context` 由来の見た目設定が未設定の場合に生成するサンプル内容の例。実際には `assets/sample-plan.html` を参考にして、動的に同様の内容を生成する。

- タイトル: 「APIサーバー構築フロー（サンプル）」
- canvas図: 設計〜実装〜テスト〜デプロイのフローを canvas（ノード矩形＋矢印）で描画
- ステップ詳細: 各フェーズの補足説明をグリッドカードで配置
- スタイル: ダークテーマ、アクセント `#00ffcc`、シャープな角

## 8. エラー処理

- `user-context` プロファイルが未ロードの場合: このスキルの実行を中止し、`user-context` の完了を要求する。
- ブラウザ起動コマンドが失敗した場合: ファイルパスをユーザーに提示し、手動で開くよう案内する。
- `/tmp/agents_plans/` ディレクトリの作成に失敗した場合: エラーを報告し、代替の保存先をユーザーに確認する。
