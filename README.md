# neovim-config

Neovim の個人設定。Neovim **0.12+** 前提。`~/.config/nvim` をこのリポジトリの
`nvim/` への symlink にして使う。

## セットアップ

```sh
ghq get github.com/nesheep5/neovim-config
cd ~/ghq/github.com/nesheep5/neovim-config
./setup.sh
```

`setup.sh` が `~/.config/nvim` をこのリポジトリの `nvim/` への symlink にする。
既存の `~/.config/nvim` が実体なら `.bak.<日時>` に退避してから張り替える（冪等）。

手動で張る場合:

```sh
ln -sfn ~/ghq/github.com/nesheep5/neovim-config/nvim ~/.config/nvim
```

設定は `~/.config/nvim/...`（symlink 経由）を直接編集すれば、このリポジトリの実体が変わる。

## 前提ツール

- Neovim 0.12 以上
- `tree-sitter` CLI 0.26.1 以上（treesitter パーサのコンパイルに必要）
  - `brew install tree-sitter-cli`
- 各 LSP サーバは mason が自動インストールする（`:Mason`）

## 構成

`nvim/` が `~/.config/nvim` の実体（symlink 先）。

```
neovim-config/                  # リポジトリ
└── nvim/                       # = ~/.config/nvim (symlink 先)
    ├── init.lua
    ├── lsp/                    # 各 LSP サーバ設定 (runtimepath 直下、自動ロード)
    │   └── <server>.lua
    └── lua/
        ├── config/
        │   ├── lsp.lua         # diagnostic / capabilities / キーマップ / enable
        │   ├── lazy.lua        # プラグイン管理 (lazy.nvim) + mason
        │   ├── options.lua
        │   ├── keymaps.lua
        │   └── autocmds.lua
        └── plugins/            # プラグインごとの設定
```

## LSP

Neovim 0.11+ のネイティブ方式を使う。

- 各サーバ設定は `lsp/<server>.lua` に置く（`vim.lsp.config` が自動ロード）。
- 共通設定・有効化は `lua/config/lsp.lua`（`vim.lsp.enable`）。
- サーバ本体のインストールは mason、設定集は nvim-lspconfig が補完する。
- 補完は nvim-cmp ではなく Neovim 0.12 ネイティブ補完（`vim.lsp.completion`）。
