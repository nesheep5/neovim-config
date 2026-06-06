-- miseはPATHを動的に作成するので、shimsを設定する
--vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.g.mapleader = " " -- vim.keymapより前に置くこと

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("config.lsp")
