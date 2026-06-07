# Markdown 表示・編集環境の刷新 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** nvim 内の Markdown 表示を素テキスト + シンタックスハイライトに振り切り、レンダリング確認をブラウザライブプレビュー（markdown-preview.nvim / peek.nvim 併用）に一本化する。

**Architecture:** インライン装飾系プラグイン（render-markdown / image / diagram）を削除し、代わりにブラウザプレビュー系プラグイン 2 種を追加する。Treesitter のシンタックスハイライトは既存設定をそのまま維持する。キーマップは各プラグインの lua spec 内 `keys` で `ft = "markdown"` 限定で定義する。

**Tech Stack:** Neovim (lazy.nvim), Lua, markdown-preview.nvim (Node/npm), peek.nvim (Deno), which-key.nvim

**作業ディレクトリ:** `~/.config/nvim`（git 管理下）。すべてのパスはこのディレクトリ基準。

**テスト方針:** Neovim のプラグイン設定変更はユニットテストに馴染まないため、各タスクで `nvim --headless` での Lua ロードエラー検査と、対話起動での手動検証を「検証ステップ」として実施する。

---

### Task 1: render-markdown / image / diagram プラグインを削除

**Files:**
- Delete: `lua/plugins/render-markdown.lua`
- Delete: `lua/plugins/diagram.lua`
- Delete: `lua/plugins/image.lua`

- [ ] **Step 1: 3 ファイルを削除**

```bash
cd ~/.config/nvim
git rm lua/plugins/render-markdown.lua lua/plugins/diagram.lua lua/plugins/image.lua
```

- [ ] **Step 2: 削除されたことを確認**

Run: `ls lua/plugins/ | grep -E 'render-markdown|diagram|image'`
Expected: 何も出力されない（終了コード 1）

- [ ] **Step 3: Lua 構文・ロードエラーが無いことを確認**

Run: `nvim --headless "+Lazy! sync" +qa 2>&1 | tail -20`
Expected: エラーが出ず、render-markdown / image / diagram が `removed` として処理される。`Error` の文字列が出ないこと。

> 補足: `Lazy! sync` は lazy-lock.json を更新し、削除されたプラグインを clean する。`!` は確認プロンプトをスキップする。

- [ ] **Step 4: コミット**

```bash
cd ~/.config/nvim
git add -A
git commit -m "render-markdown/image/diagramを削除

nvim内のMarkdown表示を素テキスト+シンタックスハイライトに
振り切るため、インライン装飾・ターミナル画像描画系を削除。
レンダリング確認はブラウザプレビューに移行する。"
```

---

### Task 2: Treesitter のシンタックスハイライト維持を確認

このタスクは変更なし。削除によって markdown のシンタックスハイライトが壊れていないことを確認するだけの検証タスク。

**Files:**
- Verify only: `lua/plugins/nvim-treesitter.lua`

- [ ] **Step 1: markdown パーサが ensure に残っていることを確認**

Run: `grep -n 'markdown' lua/plugins/nvim-treesitter.lua`
Expected: `ensure` テーブル内の `"markdown"` / `"markdown_inline"` と、FileType autocmd pattern 内の `"markdown"` が表示される（計 3 箇所程度）。1 つも無ければ Task 1 で誤って treesitter 設定を触っている。

- [ ] **Step 2: 実ファイルでシンタックスハイライトを目視確認**

Run: `nvim docs/superpowers/specs/2026-06-07-markdown-preview-design.md`
手順: 見出し `#` やコードブロック、テーブルが**素のテキストのまま**、かつ Treesitter による色分け（見出し・コードフェンス等が色付き）で表示されること。インライン装飾（`#` が消えてアイコン化される等）が**起きていない**こと。確認したら `:q` で終了。
Expected: 素テキスト + 色分けのみ。装飾レンダリングなし。

> このタスクはコミット不要（変更なし）。

---

### Task 3: markdown-preview.nvim を追加

**Files:**
- Create: `lua/plugins/markdown-preview.lua`

- [ ] **Step 1: プラグイン spec を作成**

`lua/plugins/markdown-preview.lua` を以下の内容で作成する:

```lua
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
```

- [ ] **Step 2: ビルドを含めてプラグインを取得**

Run: `nvim --headless "+Lazy! sync" +qa 2>&1 | tail -30`
Expected: `markdown-preview.nvim` が `installed` となり、build（`cd app && npx --yes yarn install`）が成功する。`Error` が出ないこと。

> ビルドに失敗した場合: spec の `build` をコメントのプリビルド方式（`vim.fn["mkdp#util#install"]()`）に差し替えて再度 `Lazy! sync` する。

- [ ] **Step 3: プレビューの起動を手動検証**

Run: `nvim docs/superpowers/specs/2026-06-07-markdown-preview-design.md`
手順: ノーマルモードで `<Space>mp`（leader = Space）を押す。ブラウザが開き、設計ドキュメントが GitHub 風にレンダリング表示されること。もう一度 `<Space>mp` でプレビューが閉じること。確認後 `:q`。
Expected: ブラウザでレンダリング表示 → トグルで開閉。

- [ ] **Step 4: コミット**

```bash
cd ~/.config/nvim
git add lua/plugins/markdown-preview.lua lazy-lock.json
git commit -m "markdown-preview.nvimを追加

ブラウザライブプレビュー(<leader>mp)を導入。GitHub風スタイルで
表示再現度が高い。yarn無し環境のためnpx経由でビルドする。"
```

---

### Task 4: peek.nvim を追加

**Files:**
- Create: `lua/plugins/peek.lua`

- [ ] **Step 1: プラグイン spec を作成**

`lua/plugins/peek.lua` を以下の内容で作成する:

```lua
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
```

> 注: peek は `ft` 限定だが `keys` でも遅延ロードされる。`config` 内の `require("peek")` はプラグインロード後に評価されるため問題ない。

- [ ] **Step 2: ビルドを含めてプラグインを取得**

Run: `nvim --headless "+Lazy! sync" +qa 2>&1 | tail -30`
Expected: `peek.nvim` が `installed` となり、build（`deno task --quiet build:fast`）が成功する。`Error` が出ないこと。

- [ ] **Step 3: プレビューの起動を手動検証**

Run: `nvim docs/superpowers/specs/2026-06-07-markdown-preview-design.md`
手順: ノーマルモードで `<Space>mk` を押す。ブラウザが開きレンダリング表示されること。もう一度 `<Space>mk` で閉じること。確認後 `:q`。
Expected: ブラウザでレンダリング表示 → トグルで開閉。

- [ ] **Step 4: コミット**

```bash
cd ~/.config/nvim
git add lua/plugins/peek.lua lazy-lock.json
git commit -m "peek.nvimを追加

Deno製のブラウザライブプレビュー(<leader>mk)を導入。
markdown-preview.nvimとの使い比べ用に併用する。"
```

---

### Task 5: which-key に Markdown グループを追加

**Files:**
- Modify: `lua/plugins/which-key.lua`

- [ ] **Step 1: opts に spec を追加して `<leader>m` をグループ化**

`lua/plugins/which-key.lua` の `opts = {}`（空テーブル）を以下に置き換える:

```lua
  opts = {
    spec = {
      { "<leader>m", group = "Markdown" },
    },
  },
```

変更後のファイル全体は以下:

```lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>m", group = "Markdown" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
```

- [ ] **Step 2: Lua ロードエラーが無いことを確認**

Run: `nvim --headless "+lua require('lazy.core.config')" +qa 2>&1 | tail -10`
Expected: エラー出力なし。

- [ ] **Step 3: which-key グループ表示を手動検証**

Run: `nvim docs/superpowers/specs/2026-06-07-markdown-preview-design.md`
手順: ノーマルモードで `<Space>m` を押して少し待つ。which-key のポップアップに `+Markdown` グループが表示され、配下に `p`（ブラウザプレビュー トグル）と `k`（peek プレビュー トグル）が見えること。`<Esc>` でキャンセル後 `:q`。
Expected: `<leader>m` 配下に Markdown グループと mp/mk が表示される。

- [ ] **Step 4: コミット**

```bash
cd ~/.config/nvim
git add lua/plugins/which-key.lua
git commit -m "which-keyにMarkdownグループを追加

<leader>m配下をMarkdownグループとして表示し、mp/mkの
プレビュートグルを見やすくする。"
```

---

### Task 6: 全体動作の最終確認

すべての変更を統合した状態で破綻が無いことを確認する検証タスク。

**Files:**
- Verify only

- [ ] **Step 1: クリーンな起動でエラーが無いことを確認**

Run: `nvim --headless "+checkhealth lazy" +qa 2>&1 | grep -iE 'error|fail' || echo "no errors"`
Expected: `no errors`（または致命的でない警告のみ）。

- [ ] **Step 2: 削除済みプラグインが残っていないことを確認**

Run: `ls lua/plugins/ | grep -E 'render-markdown|diagram|image' || echo "clean"`
Expected: `clean`

- [ ] **Step 3: 追加プラグインが揃っていることを確認**

Run: `ls lua/plugins/ | grep -E 'markdown-preview|peek'`
Expected: `markdown-preview.lua` と `peek.lua` の両方が表示される。

- [ ] **Step 4: 実利用シナリオの総合手動検証**

Run: `nvim docs/superpowers/specs/2026-06-07-markdown-preview-design.md`
手順:
1. 素テキスト + シンタックスハイライトで表示される（装飾なし）
2. `<Space>mp` でブラウザプレビューが開閉する
3. `<Space>mk` で peek プレビューが開閉する
4. `<Space>m` で which-key に Markdown グループが出る
すべて確認後 `:q`。
Expected: 4 項目すべて成功。

> このタスクはコミット不要（検証のみ）。問題があれば該当タスクに戻る。

---

## 完了後の運用メモ

`mp` / `mk` を実使用で打ち比べ、表示再現度（GitHub 風）と起動の快適さで好みを判断する。
1 本化を決めたら、不要な側のプラグインファイル（`markdown-preview.lua` または `peek.lua`）を削除し、
which-key spec から該当キーの記述を整理する。これは本プランのスコープ外（後日の別作業）。
