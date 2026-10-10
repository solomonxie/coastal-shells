# coastal-shells

Zsh config with no framework: hand-picked plugins, a fast git prompt, aliases and functions, plus tmux window marks for finished commands, `(✓)` or `(✗)`.

Lives in `~/.config/zsh`; `install.sh` links `~/.zshrc` to `zshrc-mac.zsh`. Machine-local overrides go in `~/.bashrc-local` (bash-compatible, sourced near the end), e.g. `ZSH_PROMPT_HOST=work` or `_ZSH_COMMAND_PREFIX='$'`.

## Install

```sh
git clone https://github.com/solomonxie/coastal-shells.git ~/.config/zsh
~/.config/zsh/install.sh
```

Existing symlinks are replaced; real files at a target path are moved to `<path>.bak.<timestamp>`.
