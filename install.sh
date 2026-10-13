#!/usr/bin/env bash
# Symlink this repo into place. Existing symlinks are replaced; real files are moved to <path>.bak.<timestamp>.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)

link() {  # link <path in repo, empty = repo root> <dest>
  local src=$here${1:+/$1} dest=$2
  [ "$src" -ef "$dest" ] && return
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"; fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

# install.sh [zsh]  zsh: ~/.config/zsh -> zsh/, ~/.config/bash -> bash/, ~/.zshrc -> zsh/zshrc-mac.zsh
# install.sh bash   bash: ~/.config/bash -> bash/, ~/.bashrc -> bash/bashrc.sh
# install.sh mini   plain bash (e.g. a Linux server): ~/.bashrc -> bash/bashrc-mini.sh
case "${1:-zsh}" in
  zsh)
    link zsh ~/.config/zsh
    link bash ~/.config/bash
    link zsh/zshrc-mac.zsh ~/.zshrc
    ;;
  bash) link bash ~/.config/bash; link bash/bashrc.sh ~/.bashrc ;;
  mini) link bash/bashrc-mini.sh ~/.bashrc ;;
  *) echo "usage: $0 [zsh|bash|mini]" >&2; exit 1 ;;
esac
