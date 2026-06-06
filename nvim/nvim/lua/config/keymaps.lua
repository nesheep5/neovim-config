vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- window
vim.keymap.set("n", "ss", "<c-w>s")
vim.keymap.set("n", "sv", "<c-w>v")
vim.keymap.set("n", "sh", "<c-w>h")
vim.keymap.set("n", "sj", "<c-w>j")
vim.keymap.set("n", "sk", "<c-w>k")
vim.keymap.set("n", "sl", "<c-w>l")

vim.keymap.set("n", "<leader>,", ":e ~/.config/nvim/init.lua<cr>")

-- github url copy
vim.keymap.set("n", "<leader>gy", function()
  require("utils.github_url").copy_github_url()
end, { desc = "Copy GitHub URL of current line" })

-- 相対パスをコピーするキーマッピング
vim.keymap.set('n', '<leader>cp', function()
  local relative_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')
  vim.fn.setreg('+', relative_path)
  vim.notify('Copied to clipboard: ' .. relative_path)
end, { desc = 'Copy relative file path' })

-- 設定リロード用のキーマッピング
vim.keymap.set('n', '<leader>r', function()
  -- Luaのキャッシュをクリア
  for name, _ in pairs(package.loaded) do
    if name:match('^user') or name:match('^plugins') then
      package.loaded[name] = nil
    end
  end

  -- 設定を再読み込み
  dofile(vim.env.MYVIMRC)
  vim.notify('Config reloaded!', vim.log.levels.INFO)
end, { desc = 'Reload config' })
