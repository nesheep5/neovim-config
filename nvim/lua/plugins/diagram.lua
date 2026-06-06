-- Markdown 中の mermaid コードブロックを画像化してターミナルに表示する。
-- mmdc で図をレンダリングし、image.nvim 経由で描画する。
-- 外部依存: mermaid-cli (mmdc) (`brew install mermaid-cli`)。
return {
  "3rd/diagram.nvim",
  dependencies = { "3rd/image.nvim" },
  ft = { "markdown" },
  -- integrations の require をロード後に確実に評価するため config 形式を使う。
  config = function()
    require("diagram").setup({
      integrations = { require("diagram.integrations.markdown") },
      renderer_options = {
        mermaid = {
          theme = "dark", -- tokyonight に合わせる
          background = "transparent",
          scale = 2, -- 解像度を上げて文字をくっきりさせる
        },
      },
    })
  end,
}
