vim.diagnostic.config({ virtual_text = true })

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Mason setup for automatic LSP installation
require("mason").setup()
local mason_ensure_installed = { "lua_ls", "ts_ls", "eslint" }
require("mason-lspconfig").setup({
  automatic_installation = true,
  ensure_installed = mason_ensure_installed,
})

-- Global LSP configuration using the new approach
vim.lsp.config["*"] = {
  on_attach = require("lsp.common").on_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
}

-- Configure individual LSP servers using the new approach
vim.lsp.config.lua_ls = require("lsp.lua_ls")
vim.lsp.config.ts_ls = require("lsp.ts_ls")
vim.lsp.config.eslint = require("lsp.eslint")
vim.lsp.config.ruby_lsp = require("lsp.ruby_lsp")
vim.lsp.config.sorbet = require("lsp.sorbet")
vim.lsp.config.pyright = require("lsp.pyright")
vim.lsp.config.ruff = require("lsp.ruff")

-- Enable LSP servers
vim.lsp.enable({ "lua_ls", "ts_ls", "eslint", "flow", "ruby_lsp", "sorbet", "pyright", "ruff" })
