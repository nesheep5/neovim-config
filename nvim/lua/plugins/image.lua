-- ターミナルへの画像描画基盤。Ghostty は Kitty graphics protocol に対応するため backend = "kitty"。
-- processor = "magick_cli" は ImageMagick の CLI を使うため luarocks 不要で導入が容易。
-- 外部依存: ImageMagick (`brew install imagemagick`)。diagram.nvim の土台となる。
return {
  "3rd/image.nvim",
  ft = { "markdown" },
  build = false, -- magick_cli はビルド不要 (magick_rock を使う場合のみ build が要る)
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    -- 画像描画は diagram.nvim に一本化し、同一バッファへの二重描画 (ちらつき・描画残り) を避ける。
    integrations = {
      markdown = { enabled = false },
      neorg = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
    },
    max_width_window_percentage = 100,
    max_height_window_percentage = 60,
    tmux_show_only_in_active_window = true, -- tmux のアクティブウィンドウのみ描画
    window_overlap_clear_enabled = true, -- 分割・スクロール時に重なった画像をクリア
  },
}
