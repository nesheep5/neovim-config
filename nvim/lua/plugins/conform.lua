return {
  "stevearc/conform.nvim",
  opts = {
    default_format_opts = {
      lsp_format = "fallback", -- 外部フォーマッタがない場合のみ LSP を使う
    },
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      ruby = {}, -- ruby-lsp のフォーマットに委譲 (lsp_format = fallback)
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      markdown = { "prettier" },
    },
    -- ファイル保存時にフォーマットを実行する
    format_on_save = {
      timeout_ms = 500,
    },
  },
}
