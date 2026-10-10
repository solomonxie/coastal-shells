# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/myconf/config/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/myconf/config/fzf/bin"
fi

eval "$(fzf --zsh)"
