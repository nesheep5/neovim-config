# Markdown 表示・編集環境の刷新 設計

作成日: 2026-06-07

## 背景・目的

Markdown ファイルの表示・編集を改善する。現状は `render-markdown.nvim` が
バッファ内でインライン装飾（見出し・テーブル・コードブロック等）をレンダリングし、
さらに `image.nvim` + `diagram.nvim` で mermaid 図をターミナルに画像描画している。

しかしこのインライン装飾は素のテキスト編集の邪魔になる。編集は nvim 内で
「素のテキスト + シンタックスハイライト」に振り切り、レンダリング結果の確認は
ブラウザライブプレビューに一本化する。

## ゴール

- **nvim 内**: 素の Markdown テキスト + Treesitter シンタックスハイライトのみ。インライン装飾なし。
- **確認**: ブラウザライブプレビューで行う。`markdown-preview.nvim` と `peek.nvim` の
  両方を導入し、使い比べてから後日どちらかに 1 本化する。

## 環境前提（確認済み）

| 依存 | 状態 | 用途 |
|---|---|---|
| Node.js / npm | 導入済み（node v26, npm あり。**yarn は無し**） | markdown-preview のビルド |
| Deno | 導入済み（v2.8.2） | peek のビルド |
| ImageMagick / mermaid-cli | 既存（image/diagram 用） | 削除後は不要化（アンインストールは任意・設計外） |

## 1. 削除するもの

| ファイル | 理由 |
|---|---|
| `lua/plugins/render-markdown.lua` | インライン装飾を廃止し素テキスト化 |
| `lua/plugins/diagram.lua` | mermaid 画像描画をビューアーに移管 |
| `lua/plugins/image.lua` | diagram.nvim の土台。不要化 |

### 付随確認

- `lua/plugins/nvim-treesitter.lua` の `ensure_installed` に `markdown` /
  `markdown_inline` が含まれる場合は **残す**（シンタックスハイライトに必要）。
- `lazy-lock.json` は次回 lazy 同期時に自動更新される。

## 2. 追加するもの

### `lua/plugins/markdown-preview.lua`

- リポジトリ: `iamcco/markdown-preview.nvim`
- `ft = { "markdown" }`
- ビルド: yarn 無し環境のため `build = "cd app && npx --yes yarn install"`。
  プリビルド方式（`vim.fn["mkdp#util#install"]()`）をフォールバックとしてコメントで記載。
- 表示先: デフォルトブラウザ。

### `lua/plugins/peek.lua`

- リポジトリ: `toppair/peek.nvim`
- `ft = { "markdown" }`
- ビルド: `build = "deno task --quiet build:fast"`（Deno 導入済み）
- 表示先: まず `app = 'browser'` で markdown-preview と同条件比較。
  webview 表示は後で試せるようコメントで残す。
- トグルは Lua 関数で実装（`require("peek").is_open()` で開閉判定 →
  `Peek` / `PeekClose` を呼び分け）。

## 3. キーマップ設計

`<leader>m*` 系は render-markdown 削除に伴い全て空く。`<leader>m` を
**Markdown グループ**として再利用する。既存キーマップ（`<leader>g*` /
`<leader>c*` / `<leader>r` / `<leader>,`）との衝突なし。

| キー | 動作 | プラグイン |
|---|---|---|
| `<leader>mp` | プレビュー トグル | markdown-preview.nvim（**p**review） |
| `<leader>mk` | プレビュー トグル | peek.nvim（pee**k**） |

- 両方とも `ft = "markdown"` 限定。markdown バッファでのみ有効。
- markdown-preview: `<Plug>(MarkdownPreviewToggle)`。
- peek: 開閉判定する Lua 関数。
- which-key: `lua/plugins/which-key.lua` の `opts.spec`（または同等の登録）に
  `{ "<leader>m", group = "Markdown" }` を追加し「Markdown」グループとして表示。

## 4. 使い比べと 1 本化の運用

`mp` / `mk` を打ち比べ、表示再現度（GitHub 風の見た目）と小窓の快適さを実感する。
後日どちらかに決めたら、不要なプラグインファイルを削除しキーマップを整理して 1 本化する。

## スコープ外

- ImageMagick / mermaid-cli のアンインストール（任意）。
- ターミナル別ペイン（glow 等）の TUI プレビュー。
- Obsidian/Typora 等の外部アプリ連携。
