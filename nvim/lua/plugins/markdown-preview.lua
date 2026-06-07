-- Markdown をブラウザでライブプレビューする。
-- 保存・編集に連動してリアルタイム更新し、mermaid/katex/PlantUML も
-- ブラウザ側でレンダリングされる。GitHub 風スタイルで表示再現度が高い。
-- 外部依存: Node.js / npm。ビルドで app ディレクトリの依存を取得する。
return {
  "iamcco/markdown-preview.nvim",
  -- yarn 無し環境のため npx 経由で yarn を呼ぶ。
  -- ビルドが詰まる場合は下のプリビルド方式に切り替える:
  --   build = function() vim.fn["mkdp#util#install"]() end,
  build = "cd app && npx --yes yarn install",
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      "<Plug>(MarkdownPreviewToggle)",
      desc = "Markdown: ブラウザプレビュー トグル",
      ft = "markdown",
    },
  },
}
