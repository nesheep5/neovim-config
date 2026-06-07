-- Markdown をブラウザでライブプレビューする。
-- 保存・編集に連動してリアルタイム更新し、mermaid/katex/PlantUML も
-- ブラウザ側でレンダリングされる。GitHub 風スタイルで表示再現度が高い。
-- 外部依存: Node.js / npm。ビルドで app ディレクトリの依存を取得する。
--
-- リモート(EC2/Ubuntu を SSH 経由で使う)場合の指針:
--   このプラグインはローカルにプレビュー用 HTTP サーバを立て、ブラウザで開く方式。
--   サーバ側に GUI ブラウザは不要で、手元の PC のブラウザで見るよう設定できる。
--     - vim.g.mkdp_open_ip   : サーバが bind する IP（手元から到達できるアドレス）
--     - vim.g.mkdp_port      : 固定ポート（SSH ポートフォワードと併用しやすい）
--     - vim.g.mkdp_browserfunc / mkdp_open_to_the_world も用途に応じて利用可
--   典型: ssh -L 8888:localhost:8888 でローカル転送し、手元ブラウザで localhost:8888 を開く。
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
      "<Plug>MarkdownPreviewToggle",
      desc = "Markdown: ブラウザプレビュー トグル",
      ft = "markdown",
    },
  },
}
