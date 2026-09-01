# dotfiles

Personal configuration, kept in one place and linked out to where each tool
expects to find it.

```
agents/AGENTS.md            ->  ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md
ghostty/config              ->  ~/.config/ghostty/config
karabiner/karabiner.edn     ->  ~/.config/karabiner.edn   (then built by goku)
nvim/                       ->  ~/.config/nvim
tmux/tmux.conf              ->  ~/.config/tmux/tmux.conf
zsh/{zshenv,zprofile,zshrc} ->  ~/.zshenv, ~/.zprofile, ~/.zshrc
```

## Install

```sh
./install.sh          # symlinks, and build the Karabiner config
./install.sh --tools  # also install the CLI tools, language servers and formatters
```

Re-runnable. A destination that is a real file rather than a symlink is
reported and left alone, so a config edited in place is never silently
replaced — move it aside and re-run.

Symlinks and a script rather than a dotfile manager, because two of these are
not plain file copies: Karabiner needs a build step (`goku`), and the agents
file is one source installed under two different names.

## What's here

**agents** — instructions Claude Code and Codex both load, as a single file
linked under the name each tool expects.

**ghostty** — terminal config. Its theme matches Neovim's, and tmux follows
the terminal palette, so the three agree.

**karabiner** — keyboard remapping: `caps_lock` to escape/command, shifts to
control, a hyper key, and a symbol layer on the home row. Written in goku's
edn format rather than Karabiner's generated JSON. See
[karabiner/README.md](karabiner/README.md).

**nvim** — editor config. Ten plugins on Nvim 0.12's built-in plugin manager
and completion, using core's default keymaps rather than redefining them. See
[nvim/README.md](nvim/README.md).

**tmux** — terminal multiplexer config. Plugin-free, so a fresh machine needs
no plugin manager.

**zsh** — shell config: completions, fzf history search, autosuggestions and
syntax highlighting. Per-machine values live in untracked `.local` files. See
[zsh/README.md](zsh/README.md).

## Requirements

```sh
brew install goku tmux neovim yazi
brew install --cask ghostty
./install.sh --tools  # fzf, ripgrep, fd, tree-sitter, language servers, formatters
```

Neovim must be 0.12 or newer.

Karabiner-Elements is installed separately from
[karabiner-elements.pqrs.org](https://karabiner-elements.pqrs.org).
