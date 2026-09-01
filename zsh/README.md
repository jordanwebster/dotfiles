# zsh

```
zshenv    -> ~/.zshenv     every zsh, including scripts and subprocesses
zprofile  -> ~/.zprofile   login shells
zshrc     -> ~/.zshrc      interactive shells — everything below lives here
```

Startup went from ~676ms to ~51ms per shell, which matters because tmux opens
a new one for every pane.

## What changed and why

**nvm was 92% of startup.** Sourcing `nvm.sh` costs ~285ms, nearly all of it
activating the default version. That version lives at a fixed path, so
`zshrc` puts it on `PATH` directly and defines `nvm` as a stub that loads the
real thing on first call. `node`, `npm` and `npx` work immediately; `nvm use`
still works, just a beat slower the first time.

**Completions were never initialised.** Nothing in the old config called
`compinit` — they worked only because the gcloud SDK's completion script ran
it as a side effect, which meant they would have vanished silently if gcloud
were ever removed. It now runs deliberately, with the security audit done
once a day rather than on every shell.

**Removed:** gcloud (unused since November 2023), `~/.amux/bin` (an empty
directory), rbenv (ruby 2.7.6, no Gemfile anywhere in `~/source`), and the
JetBrains Toolbox path. `PATH` is now `typeset -U`, so the duplicate
`~/.local/bin` cannot come back.

The prompt is deliberately left as zsh's default.

## Secrets

`~/.zshenv.local` is untracked, mode 600, and sourced by `zshenv` if it
exists. Machine-local values go there.

Be aware of what that costs: `.zshenv` is read by **every** zsh — scripts,
subprocesses, anything a program spawns — so everything in it is inherited by
everything else. That is where these values already were, so this is not a
regression, but it is not the goal either. Better options, in order:

1. **macOS keychain**, read on demand, so nothing sits in the environment:
   ```sh
   security add-generic-password -a "$USER" -s linear-api -w   # store once
   security find-generic-password -a "$USER" -s linear-api -w  # read
   ```
2. **direnv**, for anything project-scoped: a gitignored `.envrc` per repo, so
   the value exists only inside that directory.
3. **sops + age** (both already installed) if a secret should travel with this
   repo, encrypted.

## Things worth knowing

```
Ctrl-R        fuzzy history search (fzf)
Ctrl-T        insert a file path       Alt-C   cd into a directory
Up / Down     search history for what is already typed
Ctrl-X Ctrl-E open the current line in $EDITOR
Right arrow   accept the greyed-out suggestion
z foo         jump to the directory called foo you use most (zoxide)
!!            previous command         !$      its last argument
Esc .         insert last argument (repeat to cycle further back)
dirs -v       numbered directory stack; then `cd -2`
```

`AUTO_CD` means a bare directory name changes to it. A leading space keeps a
command out of history. `**/*.rs` is a recursive glob; `*(.)` matches only
files, `*(/)` only directories, `*(om[1])` the most recently modified.
