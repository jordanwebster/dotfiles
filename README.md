# dotfiles

Personal configuration, kept in one place and linked out to where each tool
expects to find it.

```
agents/global-agents.md   ->  ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md
ghostty/config            ->  ~/.config/ghostty/config
karabiner/karabiner.edn   ->  ~/.config/karabiner.edn   (then built by goku)
nvim/                     ->  ~/.config/nvim
tmux/tmux.conf            ->  ~/.config/tmux/tmux.conf
```

## Install

```sh
./install.sh          # symlinks + build the Karabiner config
./install.sh --tools  # also install the CLI tools, language servers and formatters
```

Re-runnable. It creates the symlinks above and then runs `goku` to build the
Karabiner config. A destination that is a real file rather than a symlink is
reported and left alone, so nothing edited in place is silently replaced —
move it aside and re-run.

`install.sh` uses symlinks rather than a dotfile manager because two of these
are not plain file copies: Karabiner needs a *build* step (`goku`), and the
agents file is one source installed under two different names. Stow can do
neither, and neither is enough work to justify chezmoi.

## What's here

**agents** — the global instructions Claude Code and Codex both load, as a
single file linked under each tool's expected name. Previously lived in
`~/source/skills`.

**ghostty** — terminal config. Replaces an Alacritty config that outlived
its terminal. Its theme matches Neovim's, and tmux follows the terminal
palette, so the three agree.

**karabiner** — keyboard remapping: `caps_lock` to escape/command, shifts to
control, a hyper key, and a symbol layer on the home row. Written in goku's
edn format rather than Karabiner's generated JSON. See
[karabiner/README.md](karabiner/README.md).

**nvim** — editor config. Ten plugins on Nvim 0.12's built-in plugin
manager and completion, leaning on core's default keymaps rather than
redefining them. See [nvim/README.md](nvim/README.md).

**tmux** — terminal multiplexer config. Plugin-free: the settings tmux-sensible
used to provide are inlined, so a fresh machine needs no plugin manager.

## Requirements

```sh
brew install goku tmux neovim yazi
brew install --cask ghostty
./install.sh --tools  # fzf, ripgrep, fd, tree-sitter, language servers, formatters
```

Neovim must be 0.12 or newer.

Karabiner-Elements is installed separately from
[karabiner-elements.pqrs.org](https://karabiner-elements.pqrs.org).
