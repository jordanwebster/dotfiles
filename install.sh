#!/usr/bin/env bash
#
# Link this checkout's configuration into the places each tool actually reads
# from, and build the one config that is generated rather than linked.
#
# Safe to re-run. A destination that is a real file rather than a link is left
# alone and reported, so a config someone edited in place is never silently
# replaced by this checkout's copy.
#
# Usage: ./install.sh [--tools]
#   --tools  also install everything nvim shells out to: the fzf/ripgrep/fd
#            CLI tools, tree-sitter, language servers and formatters

set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
status=0
with_tools=false

while [ "$#" -gt 0 ]; do
    case $1 in
        --tools|--lsp) with_tools=true ;;   # --lsp kept: it is what the first README said
        -h|--help)
            echo "usage: ./install.sh [--tools]"
            echo "  --tools  also install everything nvim shells out to: fzf,"
            echo "           ripgrep, fd, tree-sitter, language servers, formatters"
            exit 0
            ;;
        *) echo "unknown option: $1" >&2; exit 2 ;;
    esac
    shift
done

# Point $2 at $1 (a path relative to this checkout), creating parents as needed.
link() {
    local source=$repo/$1 target=$2

    if [ ! -e "$source" ]; then
        echo "SKIPPED:  $1 is not in this checkout yet"
        return
    fi

    if [ -L "$target" ]; then
        if [ "$target" -ef "$source" ]; then
            echo "CURRENT:  $target"
            return
        fi
        # Replacing a symlink loses nothing: no content lives in one.
        rm "$target"
    elif [ -e "$target" ]; then
        echo "REFUSED:  $target exists and is not a symlink — move it aside" >&2
        status=1
        return
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
    echo "LINKED:   $target -> $source"
}

link tmux/tmux.conf          "$HOME/.config/tmux/tmux.conf"
link nvim                    "$HOME/.config/nvim"
link ghostty/config          "$HOME/.config/ghostty/config"
link karabiner/karabiner.edn "$HOME/.config/karabiner.edn"

# One file under two names: Claude reads CLAUDE.md, Codex reads AGENTS.md.
link agents/global-agents.md "$HOME/.claude/CLAUDE.md"
link agents/global-agents.md "$HOME/.codex/AGENTS.md"

# tmux 3.1 and later prefer ~/.config/tmux/tmux.conf, but still read
# ~/.tmux.conf when it exists — which is where this repo used to install it.
# Left behind, the old path wins and edits here appear to do nothing.
if [ -L "$HOME/.tmux.conf" ]; then
    rm "$HOME/.tmux.conf"
    echo "REMOVED:  $HOME/.tmux.conf (superseded by ~/.config/tmux/tmux.conf)"
fi

# karabiner.json is generated from karabiner.edn, never linked: Karabiner-
# Elements rewrites that file itself (device settings, other profiles), so it
# cannot be a link into this checkout. goku merges this repo's rules into the
# live file, leaving the rest of Karabiner's state alone.
if command -v goku >/dev/null 2>&1; then
    # goku 0.5.7 writes correct output and then dies with a StackOverflowError
    # on its own exit path, so its exit status says nothing about success.
    goku >/dev/null 2>&1 || true
    echo "BUILT:    ~/.config/karabiner/karabiner.json (goku)"
else
    echo "SKIPPED:  goku is not installed — brew install yqrashawn/goku/goku" >&2
    status=1
fi


# Language servers and formatters.
#
# Deliberately not mason: rust-analyzer must match the toolchain that rustup
# installed, and Python tooling wants to be the project's own version, so both
# belong to their language's package manager rather than to a copy the editor
# keeps. Everything here is pinned by that manager and visible in git.
if $with_tools; then
    echo
    echo "Installing the tools nvim expects..."

    have() { command -v "$1" >/dev/null 2>&1; }
    note() { printf "  %-26s %s\n" "$1" "$2"; }

    if have brew; then
        # fzf-lua shells out to all four of these. Without fzf in particular
        # every picker in the editor silently fails, so they are not optional
        # extras -- they are what makes <leader>f work at all.
        #
        # tree-sitter-cli is required by nvim-treesitter's `main` branch, which
        # compiles parsers locally. The npm build of it is not supported.
        brew install --quiet fzf ripgrep fd bat \
            tree-sitter-cli lua-language-server stylua biome 2>&1 \
            | grep -vE "^(Warning: .* already installed|==> (Downloading|Pouring|Fetching))" || true
        note "fzf, ripgrep, fd, bat" "brew (fzf-lua needs these)"
        note "tree-sitter-cli, lua_ls, stylua, biome" "brew"
    else
        note "brew" "MISSING - skipped brew-installed tools"
        status=1
    fi

    if have uv; then
        uv tool install --quiet ty >/dev/null 2>&1 || true
        uv tool install --quiet ruff >/dev/null 2>&1 || true
        note "ty, ruff" "uv (ruff is both linter and formatter)"
    else
        note "uv" "MISSING - skipped ty and ruff"
        status=1
    fi

    if have npm; then
        # tsgo: TypeScript 7 ships only tsc in the `typescript` package, so the
        # language server comes from the native-preview build instead.
        npm install -g --silent @typescript/native-preview >/dev/null 2>&1 || true
        note "tsgo" "npm"
    else
        note "npm" "MISSING - skipped tsgo"
        status=1
    fi

    if have go; then
        go install golang.org/x/tools/gopls@latest >/dev/null 2>&1 || true
        note "gopls" "go install"
    fi

    if have rustup; then
        rustup component add rust-analyzer >/dev/null 2>&1 || true
        note "rust-analyzer" "rustup (must match the toolchain)"
    fi

    if have dotnet; then
        # The Azure DevOps feed is updated far more often than nuget.org, and is
        # the one the VS Code C# extension itself uses.
        dotnet tool install -g roslyn-language-server --prerelease \
            --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json \
            >/dev/null 2>&1 || true
        note "roslyn-language-server" "dotnet tool"
    fi
fi

exit $status
