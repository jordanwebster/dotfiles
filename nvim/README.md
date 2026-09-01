# Neovim

Requires **Nvim 0.12+**. Eight plugins, managed by `vim.pack` (built in).

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

Nvim 0.12 absorbed most of what a 2023 config needed plugins for. This one
leans on that rather than working around it:

| Was a plugin | Now built in |
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
documents — which matters more than familiarity in a config touched rarely.

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
]c [c         next/prev git hunk      <leader>fh  help tags
<leader>gp    preview hunk            <leader>fw  grep word under cursor
<leader>gb    blame line              <leader>fr  resume last picker
<leader>gd    diff this file          <leader>fd  diagnostics
                                      <leader>fs  symbols (this file)
<Esc><Esc>    leave terminal mode     <leader>fS  symbols (workspace)
                                      <leader>ft  find types (workspace)
```

`gd` is the only LSP default overridden: Vim's builtin `gd` only searches the
current function. Bare `gr` is deliberately left unmapped — taking it would
make every `grn`/`gra`/`grr` wait out `timeoutlen` first.

`grt` and `<leader>ft` are different operations that are easy to confuse:
`grt` jumps to the type of the symbol under the cursor, `<leader>ft` searches
every type the language server knows about.

## Language servers

Installed by `../install.sh --tools`, each from its own language's package
manager — **not** mason. Two reasons that are specific rather than
philosophical: `rust-analyzer` has to match the toolchain rustup installed,
and Python tooling wants to be the project's own version. A copy the editor
manages separately would be wrong in both cases.

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

Two of these were live questions when this was written, so the reasoning is
recorded here rather than lost:

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
`ty` + `ruff` for Python, `tsc` + `biome` for JS/TS. In both cases the
formatter alone reported nothing, so lint rules were invisible in the editor
until the linter ran as a server too. ruff's hover is disabled so it and ty
do not both answer `K`; biome only attaches where a biome config exists.

Formatting is conform.nvim, running each project's own tool (ruff, rustfmt,
gofmt, biome, stylua) so that saving matches what CI would produce.

`fzf-lua` shells out to `fzf`, `ripgrep`, `fd` and `bat`. Without `fzf` in
particular every picker fails silently, so `--tools` installs them.

## Colours

One Dark, via `onedarkpro.nvim`, pinned to background `#21252b` — the exact
value Ghostty's "Atom One Dark" theme uses. That is One Dark's *darker*
variant, not the more commonly quoted `#282c34`, so taking the plugin's
default would leave the editor a few shades off the terminal around it.
tmux's status line uses palette indices rather than hex, so it follows the
terminal for free. All three backgrounds are identical, not similar.

## Maintenance

```
:lua vim.pack.update()    review the diff, :w to accept, :q to discard
:TSUpdate                 parsers, after a treesitter update (also automatic)
:checkhealth              including `vim.lsp` for what attached where
:restart                  reload after updating
```

Nothing is lazy-loaded. At eight plugins the startup cost is not worth the
indirection.
