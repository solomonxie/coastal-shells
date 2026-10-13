# shells-on-shells

Zsh config with no framework: hand-picked plugins, a fast git prompt, aliases and functions, plus tmux window marks for finished commands, `(✓)` or `(✗)`.

- `zsh/`: zsh config; `~/.config/zsh` links here, `~/.zshrc` to `zsh/zshrc-mac.zsh`.
- `bash/`: bash config, plus `bash-alias.sh` and `bash-functions.sh`, which zsh sources too; `~/.config/bash` links here.
- `fish/`: not set up yet.

Machine-local overrides go in `~/.bashrc-local` (bash-compatible, sourced near the end), e.g. `ZSH_PROMPT_HOST=work` or `_ZSH_COMMAND_PREFIX='$'`.
`~/.bashrc-local` can be a symlink into a private dotfiles repo, so this repo stays public.

## Install

```sh
git clone https://github.com/solomonxie/shells-on-shells.git ~/.config/shells-on-shells
~/.config/shells-on-shells/install.sh  # [zsh|bash|mini], default zsh
```

Existing symlinks are replaced; real files at a target path are moved to `<path>.bak.<timestamp>`.
Plugins are cloned into `~/.zsh_plugins` on first start.

## Mini

`bash/bashrc-mini.sh` is a self-contained `~/.bashrc` for plain bash (Linux servers, Raspberry Pi): history, prompt, aliases, no plugins. Sources `~/.bashrc-local` if present.

```sh
curl -fsSL https://raw.githubusercontent.com/solomonxie/shells-on-shells/master/bash/bashrc-mini.sh -o ~/.bashrc
# or, with the repo cloned: install.sh mini
```
