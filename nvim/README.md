# Neovim

Requires **Nvim 0.12+**. Ten plugins, managed by `vim.pack` (built in).

```
init.lua              plugin list, leader, treesitter update hook
lua/config/
  options.lua         editor options
  keymaps.lua         the one keymap Nvim does not already provide
  autocmds.lua        reload-on-disk-change, yank flash, cursor restore
  lsp.lua             server definitions, completion, diagnostics, gd
lua/plugins/          one file per plugin: its setup and its keymaps together
nvim-pack-lock.json   plugin versions, committed
```

## Why it is this small

Nvim 0.12 provides in core most of what used to need a plugin, and this config
leans on that rather than working around it:

| Commonly a plugin | In core |
| --- | --- |
| lazy.nvim / packer | `vim.pack` |
| nvim-cmp + 6 source plugins | `'autocomplete'` + `vim.lsp.completion` |
| vim-vsnip / LuaSnip | `vim.snippet`, `<Tab>` to jump |
| lualine | default `'statusline'` (diagnostics + LSP progress) |
| Comment.nvim | `gc` / `gcc` |
| lspconfig's `on_attach` keymaps | default `gr*` maps |
| vim-unimpaired | `[q` `]q`, `[b` `]b`, `[d` `]d`, `[<Space>` `]<Space>` |

## Keymaps

Nvim's own maps are used wherever one exists, because they are what `:help`
documents.

**Built in — nothing here is configured by this repo:**

```
grn rename         grr references      gO  document symbols   K     hover
gra code action    gri implementation  gc  toggle comment     gx    open link
grt type of symbol grx run codelens    gcc comment line
[d ]d diagnostics  [q ]q quickfix      [b ]b buffers    [<Space> ]<Space> blank line
<C-l>  clear search highlight       <C-w>d show diagnostics under cursor
<C-s>  signature help (insert)      <Tab>  jump snippet placeholder
an/in  (visual) grow/shrink treesitter selection
```

**Added here** — leader is `Space`:

```
gd            go to definition        <leader>ff  find files
gD            go to declaration       <leader>fg  grep (live, ripgrep)
                                      <leader>fb  buffers
-             files, at current file  <leader>fh  help tags
<leader>-     files, at cwd           <leader>fw  grep word under cursor
                                      <leader>fr  resume last picker
]c [c         next/prev git hunk      <leader>fd  diagnostics
<leader>gp    preview hunk            <leader>fs  symbols (this file)
<leader>gb    blame line              <leader>fS  symbols (workspace)
<leader>gd    diff this file          <leader>ft  find types (workspace)

<leader>gs    git status (files)      <Esc><Esc>  leave terminal mode
<leader>gh    git hunks (changeset)
<leader>gc    git commits (repo)
<leader>gf    git commits (this file)
```

The `<leader>g` maps split by scope: `gp`/`gb`/`gd` are gitsigns, buffer-local,
answering "what changed *here*"; `gs`/`gh`/`gc`/`gf` are fzf-lua pickers over
the whole repo. `git_hunks` puts every hunk in the working tree into a single
fuzzy-searchable list.

`-` shadows the builtin `-` motion (first non-blank of the previous line), the
same trade vim-vinegar and oil.nvim make for the key that best means "up".

`gd` is the only LSP default overridden: Vim's builtin `gd` only searches the
current function. Bare `gr` is deliberately left unmapped — taking it would
make every `grn`/`gra`/`grr` wait out `timeoutlen` first.

`grt` and `<leader>ft` are different operations that are easy to confuse:
`grt` jumps to the type of the symbol under the cursor, `<leader>ft` searches
every type the language server knows about.

## Language servers

Installed by `../install.sh --tools`, each from its own language's package
manager rather than by mason: `rust-analyzer` has to match the toolchain
rustup installed, and Python tooling should be the project's own version. A
copy the editor managed separately would be wrong in both cases.

| Language | Server | Installed by |
| --- | --- | --- |
| Python (types) | `ty` | `uv tool install ty` |
| Python (lint) | `ruff` | `uv tool install ruff` |
| TS / JS / React (types) | `tsc` | `npm i -g @typescript/native-preview` |
| TS / JS / React (lint) | `biome` | `brew` |
| Rust | `rust-analyzer` | `rustup component add` |
| Go | `gopls` | `go install` |
| C# | `roslyn-language-server` | `dotnet tool install -g` |
| Lua | `lua-language-server` | `brew` |

Two of the choices are less obvious:

- **`ty` over basedpyright.** Its LSP advertises a superset of basedpyright's
  capabilities (type hierarchy, folding and selection ranges, pull
  diagnostics), and it shares a `pyproject.toml` with ruff. It is pre-1.0,
  though: if its inference misjudges real code, `uv tool install basedpyright`
  and change the name in `vim.lsp.enable()`.
- **`tsc` over vtsls / typescript-language-server.** TypeScript 7 ships only
  `tsc` in the `typescript` package — there is no tsserver left for those two
  to wrap, so they are pinned to TypeScript 5. nvim-lspconfig's `tsc`
  definition is used unchanged: it probes which binary actually supports
  `--lsp`, prefers the project's own over the global one, and declines to
  attach to Deno projects. (`tsgo` is the same server under a deprecated
  name.)

Two languages run two servers deliberately, splitting types from lints:
`ty` + `ruff` for Python, `tsc` + `biome` for JS/TS. Running a linter only as
a formatter reports nothing, so each is also enabled as a server. ruff's hover
is disabled so it and ty do not both answer `K`; biome attaches only where a
biome config exists.

Formatting is conform.nvim, running each project's own tool (ruff, rustfmt,
gofmt, biome, stylua) so that saving matches what CI would produce.

`fzf-lua` shells out to `fzf`, `ripgrep`, `fd` and `bat`. Without `fzf` every
picker fails silently, so `--tools` installs all four.

## Colours

One Dark, via `onedarkpro.nvim`, pinned to background `#21252b` — the exact
value Ghostty's "Atom One Dark" theme uses. That is One Dark's *darker*
variant, not the more commonly quoted `#282c34`, so taking the plugin's
default would leave the editor a few shades off the terminal around it.
tmux's status line uses palette indices rather than hex, so it follows the
terminal for free. All three backgrounds are identical, not merely similar.

## Maintenance

```
:lua vim.pack.update()    review the diff, :w to accept, :q to discard
:TSUpdate                 parsers, after a treesitter update (also automatic)
:checkhealth              including `vim.lsp` for what attached where
:restart                  reload after updating
```

Nothing is lazy-loaded. At ten plugins the startup cost is not worth the
indirection.

`plenary.nvim` is present only because yazi.nvim depends on it. `vim.pack`
does not install a plugin's declared dependencies, so transitive ones are
listed explicitly in `init.lua`.

There is no diff-review plugin: the fzf-lua git pickers cover reviewing a
changeset without adding one.
