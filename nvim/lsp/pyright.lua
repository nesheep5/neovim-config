return {
  settings = {
    python = {
      -- 仮想環境のPythonを使う
      venvPath = ".",
      pythonPath = "./.venv/bin/python",
      analysis = {
        autoImportCompletions = true, -- オートインポート補完を有効化
      },
    },
  },
}
