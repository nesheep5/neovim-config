return {
  on_attach = function(client, bufnr)
    -- Call common on_attach first
    require("lsp.common").on_attach(client, bufnr)
    -- Add ruff-specific keymapping
    vim.keymap.set(
      "n",
      "glc",
      "<cmd>silent !ruff check --fix %<CR>",
      { noremap = true, silent = true, buffer = bufnr }
    )
  end,
}