# CLAUDE.md

Neovim 個人設定リポジトリ。セットアップ（symlink 配置）・前提ツールは README.md を参照。
ここでは Claude が編集時に間違えやすい点だけを記す。

## 編集対象パス（最重要）

設定の実体は `nvim/` 配下。`~/.config/nvim` はこの `nvim/` への symlink なので、
**リポジトリ内の `nvim/...` を直接編集する**。

- `init.lua` → `nvim/init.lua`
- プラグイン → `nvim/lua/plugins/`
- 共通設定 → `nvim/lua/config/`
- LSP サーバ設定 → `nvim/lsp/`

## プラグインの追加

`nvim/lua/plugins/<name>.lua` を **1ファイル追加するだけ**
（`config/lazy.lua` の `{ import = "plugins" }` が自動読み込み）。
各ファイルは lazy.nvim の spec table を `return` する形式（例: `lua/plugins/conform.lua`）。

## LSP サーバの追加（二重管理に注意）

1. `nvim/lsp/<server>.lua` にサーバ設定を置く（`vim.lsp.config` が自動ロード）。
2. **2箇所**の配列に追記して有効化する:
   - `nvim/lua/config/lazy.lua` の `ensure_installed`（mason の自動インストール）
   - `nvim/lua/config/lsp.lua` の `vim.lsp.enable({...})`（有効化を一本化）

`mason-lspconfig` は `automatic_enable = false` のため、enable は手動で書く必要がある。

## Neovim 0.12+ 前提のモダン API（旧スタイル禁止）

- 補完は **nvim-cmp ではなく** ネイティブ補完 `vim.lsp.completion`（`config/lsp.lua` の `LspAttach`）。
- LSP は 0.11+ ネイティブ方式（`vim.lsp.config` / `vim.lsp.enable`）。
  `require("lspconfig").xxx.setup{}` のような旧スタイルは使わない。
- 診断ジャンプは `vim.diagnostic.jump({ count = ... })`（非推奨の `goto_next` 等は不可）。

## フォーマット

conform.nvim による保存時フォーマット（`lua/plugins/conform.lua`）。

- lua=stylua / go=goimports+gofmt / python=ruff / ts・js・markdown=prettier
- ruby は formatter 空で **ruby-lsp に委譲**（`lsp_format = "fallback"`）

フォーマッタ本体（stylua/prettier/goimports）は **mason-tool-installer** が
自動インストールする（`config/lazy.lua`）。LSP サーバの `ensure_installed`
（mason-lspconfig 側）には書けないので、フォーマッタ等の非 LSP ツールを
追加するときは mason-tool-installer の `ensure_installed`（mason パッケージ名）に書く。

## 動作確認

- Lua 構文/ロード確認: `nvim --headless "+luafile <file>" +qa`（エラーが出なければOK）。
  エディタ上では lua_ls (LSP) が書きながら指摘する。
  ※ `luac` はこの環境に無いため使わない。
- 反映: Neovim 再起動 or `:source`。新規プラグインは `:Lazy sync`。
