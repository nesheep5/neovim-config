local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },

    -- LSP の設定集 (root_markers/cmd などの bag of configs を提供)
    { "neovim/nvim-lspconfig" },

    -- LSP サーバ本体のインストール管理
    { "mason-org/mason.nvim", opts = {} },
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      opts = {
        ensure_installed = {
          "lua_ls",
          "gopls",
          "ts_ls",
          "eslint",
          "ruby_lsp",
          "sorbet",
          "pyright",
          "ruff",
        },
        -- 有効化は config/lsp.lua の vim.lsp.enable() に一本化する
        automatic_enable = false,
      },
    },
    -- LSP サーバ以外のツール (フォーマッタ等) を mason 経由で自動インストール。
    -- ensure_installed には mason のパッケージ名を書く (conform が呼ぶ名前とは別)。
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = { "mason-org/mason.nvim" },
      opts = {
        ensure_installed = {
          "stylua", -- lua フォーマッタ
          "prettier", -- ts/js/markdown フォーマッタ
          -- goimports は go ツールチェーンがある時だけ入れる (gofmt は go 同梱で mason 不要)
          { "goimports", condition = function() return vim.fn.executable("go") == 1 end },
        },
        run_on_start = true,
      },
    },
  },
  install = { colorscheme = { "habamax" } },
  -- 起動時の更新チェック通知を無効化（更新は :Lazy で手動確認する）
  checker = { enabled = false },
  -- luarocks 依存プラグインを使わないため無効化（hererocks 環境の構築を省く）
  rocks = { enabled = false },
})
