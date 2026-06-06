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
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
