-- conform: format on save.
--
-- Every formatter here is the project's own tool, so a file formatted on save
-- matches what that project's CI would produce rather than an editor opinion.

require('conform').setup({
  formatters_by_ft = {
    python = { 'ruff_format', 'ruff_organize_imports' },
    rust = { 'rustfmt' },
    go = { 'gofmt' },
    lua = { 'stylua' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    css = { 'biome' },
  },

  -- lsp_format = 'fallback' covers filetypes with no entry above -- C# through
  -- roslyn, most obviously -- using whatever the language server offers.
  format_on_save = { timeout_ms = 2000, lsp_format = 'fallback' },
})
