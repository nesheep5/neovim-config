-- nvim-treesitter main ブランチ方式 (Neovim 0.12+ 専用)。
-- 旧 master の configs.setup{} は廃止され、パーサのインストールは install()、
-- ハイライトは FileType autocmd で vim.treesitter.start() を呼ぶ方式に変わった。
-- パーサのコンパイルに tree-sitter CLI (>= 0.26.1) が必要: `brew install tree-sitter`
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main ブランチは lazy-load 非対応
    build = ":TSUpdate",
    config = function()
      -- インストール対象のパーサ
      local ensure = {
        "fish",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "ruby",
        "go",
        "python",
        "typescript",
        "tsx",
        "markdown",
        "markdown_inline",
        "yaml",
        "html",
      }
      require("nvim-treesitter").install(ensure)

      -- FileType ごとにハイライトを有効化する。
      -- treesitter のファイルタイプ名は拡張子と一致しないものがあるため明示的に対応付ける。
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "fish",
          "lua",
          "vim",
          "help",
          "query",
          "ruby",
          "go",
          "python",
          "typescript",
          "typescriptreact",
          "markdown",
          "yaml",
          "html",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      zindex = 20,
    },
  },
}
