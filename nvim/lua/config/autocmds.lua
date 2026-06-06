vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.rbi' },
  command = 'set syntax=ruby'
})

