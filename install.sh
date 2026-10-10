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

# install.sh       zsh: the full config at ~/.config/zsh
# install.sh mini  plain bash (e.g. a Linux server): ~/.bashrc -> bashrc-mini.sh
if [ "${1:-}" = mini ]; then
  link bashrc-mini.sh ~/.bashrc
else
  link "" ~/.config/zsh
  link zshrc-mac.zsh ~/.zshrc
fi
