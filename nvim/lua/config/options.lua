-- =========================================
-- 表示系
-- =========================================
vim.opt.number = true               -- 行番号
vim.opt.cursorline = true          -- 現在行ハイライト
vim.opt.signcolumn = "yes"         -- 常にサインカラム表示
vim.opt.termguicolors = true       -- True Color有効
vim.opt.scrolloff = 10             -- 上下に余白
vim.opt.laststatus = 3             -- ステータスライン常時表示
vim.opt.showmode = false           -- モード表示を非表示
vim.opt.wrap = false               -- 行の折り返しなし
vim.opt.list = true                -- 不可視文字を表示
vim.opt.listchars = {tab = '▸ ', trail = '·'}  -- タブや行末の記号

-- =========================================
-- 操作性・挙動
-- =========================================
vim.opt.mouse = "a"                -- マウス有効
vim.opt.clipboard:append{'unnamedplus'}  -- OSクリップボード連携
vim.opt.autoread = true            -- 外部変更を自動読込
vim.opt.autowrite = true           -- 自動保存
vim.opt.keywordprg = ':help'       -- Kキーでヘルプ

-- =========================================
-- 編集・インデント
-- =========================================
vim.opt.tabstop = 2                -- タブ幅
vim.opt.shiftwidth = 2            -- インデント幅
vim.opt.expandtab  = true         -- Tabをスペースに
vim.opt.smartindent = true        -- スマートインデント
vim.opt.backspace = {"indent", "eol", "start"}  -- バックスペース拡張

-- =========================================
-- 検索
-- =========================================
vim.opt.ignorecase = true          -- 大文字小文字を無視

-- =========================================
-- ウィンドウ分割
-- =========================================
vim.opt.splitright = true          -- 右に分割

-- =========================================
-- 補完
-- =========================================
vim.opt.completeopt = {'menu', 'menuone', 'noselect', 'popup', 'fuzzy'}  -- 補完メニュー設定
vim.o.autocomplete = true          -- 入力中の自動補完ポップアップ（v0.12+）
vim.opt.pumheight = 12             -- 補完メニュー高さ上限
vim.opt.wildoptions = {'pum', 'fuzzy'}  -- コマンドライン補完もpum+ファジー

-- =========================================
-- Undo・履歴
-- =========================================
vim.opt.swapfile = false           -- スワップファイル無効
vim.opt.history = 1000             -- コマンド履歴数
vim.opt.undolevels = 10000         -- Undoの深さ
vim.opt.undofile = true            -- Undoファイル有効

-- Undo保存先を作成
local undodir = os.getenv("HOME") .. '/.local/nvim/undodir'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

-- =========================================
-- タイミング関連
-- =========================================
vim.opt.updatetime = 300           -- 更新間隔
vim.opt.timeoutlen = 500           -- キーマップ待ち時間
--vim.api.nvim_create_autocmd({'BufNewFile','BufRead'},{
--  puttern = {'help'},
--  command = '<c-w>L<cr>'
--})

