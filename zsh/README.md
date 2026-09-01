# zsh

```
zshenv    -> ~/.zshenv     every zsh, including scripts and subprocesses
zprofile  -> ~/.zprofile   login shells
zshrc     -> ~/.zshrc      interactive shells — most of the config lives here
```

The prompt is deliberately left as zsh's default.

## Node

`zshrc` puts the default node version's `bin` directory on `PATH` directly and
defines `nvm` as a stub that sources `nvm.sh` on first call. Sourcing it
eagerly costs a few hundred milliseconds per shell, nearly all of it spent
activating a version already at a known path. `node`, `npm` and `npx` are
available immediately; `nvm use` works as normal, a beat slower the first
time.

## Completions

`compinit` runs from `zshrc`, with brew's `site-functions` on `fpath`. Its
security audit of every completion file is done once a day rather than on
every shell, via the timestamp check on `~/.zcompdump`.

Completion is configured for menu selection, case-insensitive matching and
colour. The colours come from `LS_COLORS`, which is also what makes `ls`
readable, so the two are set together.

## Per-machine configuration

Zsh has no `.local` convention — it only ever reads `~/.zshenv`,
`~/.zprofile`, `~/.zshrc` and `~/.zlogin`. The two files below work because
the tracked config sources them explicitly, guarded on existence, so a machine
without them skips the line.

| File | Sourced from | Applies to | Put here |
| --- | --- | --- | --- |
| `~/.zshrc.local` | `zshrc`, before the plugins | interactive shells | aliases, `PATH`, `eval "$(tool init zsh)"`, functions |
| `~/.zshenv.local` | `zshenv`, last line | **every** zsh, scripts included | values non-interactive shells need |

Prefer `~/.zshrc.local`. `.zshenv` is read by every subprocess on the machine,
so anything in it is inherited by everything; reach for it only when something
non-interactive genuinely needs the value.

`~/.zshrc.local` is sourced *before* the plugins, not at the end of the file,
so that it can set the variables they read at load time and so that any ZLE
widget it defines is still wrapped by syntax highlighting.

This repo is public, so anything specific to one machine or organisation
belongs in those two files rather than in a tracked one.

## Secrets

Values in `~/.zshenv.local` are inherited by every process the shell spawns,
which makes it a poor home for credentials. Better options, in order:

1. **macOS keychain**, read on demand, so nothing sits in the environment:
   ```sh
   security add-generic-password -a "$USER" -s SERVICE -w   # store once
   security find-generic-password -a "$USER" -s SERVICE -w  # read
   ```
2. **direnv**, for anything project-scoped: a gitignored `.envrc` per repo, so
   the value exists only inside that directory.
3. **sops + age**, if a secret should travel with a repo, encrypted.

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
