return {
  'folke/tokyonight.nvim',
  config = function()
    require("tokyonight").setup({
      transparent = true,  -- 背景を透明化
      styles = {
        sidebars = "transparent",  -- サイドバーも透明化
        floats = "transparent",     -- フロートウィンドウも透明化
      },
      on_colors = function(colors)
        colors.border = "#565f89"
      end
    })

    vim.cmd([[colorscheme tokyonight]])

    -- 追加の透明化設定
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end
}
