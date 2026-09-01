-- Language servers.
--
-- Nvim 0.12 configures servers itself: vim.lsp.config() defines one and
-- vim.lsp.enable() starts it when a matching buffer opens. nvim-lspconfig is
-- present only as data -- it ships lsp/<name>.lua files on the runtimepath
-- supplying cmd, filetypes and root markers -- so any server enabled below
-- without a vim.lsp.config() call above is using its definition unchanged.
--
-- The servers themselves are installed by ../install.sh --tools, not by a
-- plugin. See nvim/README.md for why there is no mason here.

-- Python. ty is Astral's type checker, the same people as ruff, so both read
-- one pyproject.toml. It is pre-1.0: if its inference misjudges real code,
-- `uv tool install basedpyright` and swap the name in vim.lsp.enable() below
-- -- nothing else here depends on which one is running.
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'ruff.toml', '.git' },
})

-- Python linting, as a second server alongside ty.
--
-- ty type-checks but does not run lint rules. Running ruff only as a
-- formatter leaves unused imports, unsorted imports and dead locals
-- unreported, so it runs as a server too. Two servers on one filetype is the
-- intended arrangement: ty answers for types, ruff for lints and their fixes.
vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
})

-- TypeScript and JavaScript use nvim-lspconfig's `tsc` definition unchanged.
--
-- TypeScript 7 ships only `tsc` in the `typescript` package -- there is no
-- tsserver left for typescript-language-server or vtsls to wrap -- so this is
-- the server that tracks current TypeScript rather than TypeScript 5. The
-- shipped definition does several things a hand-written cmd cannot: it probes
-- whether tsc or tsgo actually supports --lsp (TypeScript 7+), prefers the
-- project's own node_modules/.bin over the global one, resolves monorepo
-- roots from lock files, and declines to attach to Deno projects.
--
-- `tsgo` is the same server under nvim-lspconfig's deprecated name; using it
-- warns on every attach.

-- Lua, which here means editing this config: point it at the Nvim runtime so
-- that `vim` is not reported as an undefined global.
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- rust_analyzer and gopls take nvim-lspconfig's definitions as they ship.
-- C# is not here: roslyn.nvim (plugins/roslyn.lua) has to locate and pick a
-- solution before the server can attach, which vim.lsp.enable() cannot do.
-- biome lints JS/TS and its family; tsc type-checks them. The same split as
-- ty and ruff on Python, for the same reason: without biome here, nothing
-- reports the lint rules it is configured with, even though it reformats on
-- save. Its shipped definition only attaches where a biome config exists, so
-- it stays out of the way in projects that do not use it.
vim.lsp.enable({ 'ty', 'ruff', 'tsc', 'biome', 'lua_ls', 'rust_analyzer', 'gopls' })

-- Built-in completion, driven by the language server. Replaces nvim-cmp and
-- cmp-nvim-lsp; 'autocomplete' in config/options.lua is the other half.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('dotfiles-lsp', { clear = true }),
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

    -- ruff also advertises hover, which would make every Python hover show
    -- two popups. ty is the one that knows about types, so it wins.
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

-- Go to definition.
--
-- The one LSP default this config overrides. Vim's builtin `gd` searches for
-- the identifier within the current function, which a language server does
-- strictly better, and `gd` means "go to definition" in every other editor.
-- Routed through fzf-lua so several candidates become a picker instead of a
-- quickfix list; a single candidate still jumps straight to it.
vim.keymap.set('n', 'gd', function()
  require('fzf-lua').lsp_definitions({ jump1 = true })
end, { desc = 'Go to definition' })

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })

-- Diagnostics: a gutter sign always, the message only for the line the cursor
-- is on. Whole-file virtual text pushes real code off the right of the screen.
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})
