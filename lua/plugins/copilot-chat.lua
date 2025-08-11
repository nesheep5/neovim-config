return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  },
  build = "make tiktoken",                          -- Only on MacOS or Linux
  cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatExplain", "CopilotChatFix", "CopilotChatContext" },

  keys = {
    { "<leader>cc", "<cmd>CopilotChatToggle<cr>",          desc = "Copilot Chat" },
    { "<leader>ce", ":'<,'>CopilotChatExplain<CR>",        mode = "v",               desc = "Explain Code" },
    { "<leader>cf", ":'<,'>CopilotChatFix<CR>",            mode = "v",               desc = "Fix Code" },
    { "<leader>ct", "<cmd>CopilotChatContext tabpage<CR>", desc = "Context: Tabpage" },
    { "<leader>cb", "<cmd>CopilotChatContext buffer<CR>",  desc = "Context: Buffer" },
    { "<leader>cv", "<cmd>CopilotChatContext visible<CR>", desc = "Context: Visible" },
  },

  opts = {
    model = "claude-sonnet-4",
    debug = false,
    show_folds = false,
    context = "buffer", -- buffer, tabpage, visible
    system_prompt = "あなたは親切で優秀なプログラミングアシスタントです。以後の応答はすべて日本語でお願いします。",
    prompts = {
      Explain = {
        prompt = "次のコードを日本語でわかりやすく説明してください。",
        description = "選択したコードを日本語で説明します。",
      },
      Fix = {
        prompt = "次のコードにバグがあります。修正してください。そしてその理由を日本語で説明してください。",
        description = "バグを修正し、日本語で説明します。",
      },
    },
    window = {
      layout = 'vertical',    -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
      width = 0.4,            -- fractional width of parent, or absolute width in columns when > 1
      height = 0.5,           -- fractional height of parent, or absolute height in rows when > 1
      -- Options below only apply to floating windows
      relative = 'editor',    -- 'editor', 'win', 'cursor', 'mouse'
      border = 'rounded',     -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      row = nil,              -- row position of the window, default is centered
      col = nil,              -- column position of the window, default is centered
      title = 'Copilot Chat', -- title of chat window
      footer = nil,           -- footer of chat window
      zindex = 1,             -- determines if window is on top or below other floating windows
    }
  },
  -- See Commands section for default commands if you want to lazy load on them
  --
}
