return {
  -- Pyright が hover を担うため、ruff 側の hover は無効化する
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
