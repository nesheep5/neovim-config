-- Markdown をブラウザ(または webview)でライブプレビューする。Deno 製。
-- markdown-preview.nvim との使い比べ用に併用導入する。
-- まず app = "browser" で同条件比較し、webview は後で試す。
-- 外部依存: Deno (`brew install deno`)。ビルドで webview バイナリを生成する。
return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  ft = { "markdown" },
  config = function()
    require("peek").setup({
      app = "browser", -- markdown-preview と同条件で比較。webview にするなら "webview"
    })
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  end,
  keys = {
    {
      "<leader>mk",
      function()
        local peek = require("peek")
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end,
      desc = "Markdown: peek プレビュー トグル",
      ft = "markdown",
    },
  },
}
