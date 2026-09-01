# Karabiner

`karabiner.edn` is the source. `karabiner.json` is generated from it by
[goku](https://github.com/yqrashawn/GokuRakuJoudo) and is committed only so
that the effect of an edn change is visible in a diff — nothing reads the
copy in this repo.

```
karabiner.edn  --[ goku ]-->  ~/.config/karabiner/karabiner.json
   ^                                    ^
   |                                    |
 linked here by install.sh        written by goku, and also
                                  rewritten by Karabiner-Elements
```

`~/.config/karabiner/karabiner.json` is not a symlink and must not become
one: Karabiner-Elements rewrites that file itself whenever device settings or
profiles change. goku merges this repo's rules into the `Default` profile and
leaves the rest of the file alone.

## Editing

Edit `karabiner.edn`, then apply it to the running system:

```sh
../install.sh        # links the edn into place and runs goku
# or, once linked:
goku                 # writes ~/.config/karabiner/karabiner.json
```

goku 0.5.7 writes correct output and *then* dies with a `StackOverflowError`
on its exit path. The crash is cosmetic; judge it by the file, not the exit
status. `gokuw` watches the edn and reapplies on save, if that suits better
than running `goku` by hand.

Then refresh the committed snapshot so the diff shows what changed:

```sh
./build.sh
```

## What the layout does

Held modifiers are remapped so that the strongest fingers reach the most-used
modifiers without leaving the home row:

| Physical key  | Held          | Tapped      |
| ------------- | ------------- | ----------- |
| `caps_lock`   | left command  | `escape`    |
| `left_shift`  | left control  | —           |
| `right_shift` | right control | —           |
| `left_cmd`    | left shift    | —           |
| `\`           | hyper (⌘⌃⌥⇧) | `\`         |
| `right_cmd`   | symbols layer | right cmd   |

Holding `right_command` turns the alpha keys into a symbol layer, so brackets
and operators are reachable without stretching to the number row:

|       | Left hand                     |       | Right hand                    |
| ----- | ----------------------------- | ----- | ----------------------------- |
| `q w e r t` | — `-` `+` `*` `$`       | `y u i o p` | `£` `!` `:` `;` `'`     |
| `a s d f g` | `\|` `&` `{` `(` `[`     | `h j k l ;` | `~` `_` `=` `<` `>`     |
| `z x c v b` | `\` `%` `}` `)` `]`      | `n m , . /` | `#` `?` `,` `.` `/`     |

The two hands split by role: the left hand holds openers and operators, the
right hand holds closers, punctuation and shell metacharacters.
