local function custom_on_attach(client, bufnr)
  local on_attach = require("lsp.common").on_attach
  on_attach(client, bufnr)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "glc",
    "<cmd>silent !ruff check --fix %<CR>",
    { noremap = true, silent = true }
  )
end

return {
  on_attach = custom_on_attach,
}