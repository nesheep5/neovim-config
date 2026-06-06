local M = {}

function M.copy_github_url()
  local filepath = vim.fn.expand('%:.') -- 相対パス（リポジトリルートから）
  local abs_path = vim.fn.expand('%:p')
  local line = vim.fn.line('.')

  -- Gitリポジトリのルート
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  -- 相対パスを作る
  local rel_path = vim.fn.fnamemodify(abs_path, ":." .. git_root)

  -- 現在のブランチを取得
  local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

  -- GitHubのリモートURLを取得
  local remote_url = vim.fn.systemlist("git config --get remote.origin.url")[1]

  -- https形式に変換
  remote_url = remote_url:gsub("git@github.com:", "https://github.com/")
  remote_url = remote_url:gsub("%.git$", "")

  -- URLを構築
  local url = string.format("%s/blob/%s/%s#L%d", remote_url, branch, rel_path, line)

  -- クリップボードにコピー
  vim.fn.setreg("+", url)
  vim.notify("GitHub URL copied to clipboard:\n" .. url)
end

return M
