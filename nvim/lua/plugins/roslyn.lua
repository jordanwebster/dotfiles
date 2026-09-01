-- C#: the Roslyn language server, the one VS Code's C# extension drives.
--
-- Not a plain vim.lsp.config entry in config/lsp.lua because Roslyn attaches
-- to a *solution*, not a directory: something has to find the .sln and choose
-- between them before a server can start, which vim.lsp.enable() cannot do.
--
-- Needs `roslyn-language-server` on PATH; ../install.sh --lsp installs it as a
-- dotnet global tool.

require('roslyn').setup({
  -- Search child directories for solutions too, for repos where projects are
  -- not siblings of the .sln.
  broad_search = true,
})
