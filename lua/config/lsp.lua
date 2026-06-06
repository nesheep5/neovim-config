-- LSP の中核設定。
-- 各サーバ個別の設定は runtimepath 直下の `lsp/<server>.lua` に置き、
-- Neovim が自動ロードする (0.11+ のネイティブ方式)。
-- ここでは診断表示・共通 capabilities・キーマップ・補完・有効化のみを扱う。
-- 補完は nvim-cmp ではなく Neovim 0.12+ のネイティブ補完 (vim.lsp.completion) を使う。

-- 診断の表示設定
vim.diagnostic.config({ virtual_text = true })

-- 診断ナビゲーション (グローバル)
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, opts)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- 全サーバ共通の capabilities。
-- マージしたいので代入形ではなく関数呼び出し形を使う。
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- サーバアタッチ時の処理 (キーマップ・ネイティブ補完)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Neovim 0.12+ のネイティブ自動補完を有効化
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- バッファローカルなキーマップ
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gf", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  end,
})

-- LSP サーバの有効化。filetype/root に応じて自動起動される。
vim.lsp.enable({
  "lua_ls",
  "gopls",
  "ts_ls",
  "eslint",
  "ruby_lsp",
  "sorbet",
  "pyright",
  "ruff",
})
