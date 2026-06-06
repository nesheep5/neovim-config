-- Markdown をバッファ内でインライン装飾表示する。
-- 見出し・テーブル・コードブロック・チェックボックスなどを treesitter ベースで装飾する。
-- markdown / markdown_inline パーサが必須 (nvim-treesitter.lua の ensure で install)。
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- neo-tree 経由で導入済み。アイコンプロバイダとして明示
  },
  ft = { "markdown" },
  opts = {
    completions = { lsp = { enabled = true } },
    code = { sign = true, width = "block", border = "thin" },
    heading = { sign = true },
  },
  keys = {
    { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: 装飾トグル", ft = "markdown" },
    { "<leader>me", "<cmd>RenderMarkdown expand<cr>", desc = "Markdown: anti-conceal 拡大", ft = "markdown" },
    { "<leader>mc", "<cmd>RenderMarkdown contract<cr>", desc = "Markdown: anti-conceal 縮小", ft = "markdown" },
  },
}
