# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/solomonxie/myconf/config/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/solomonxie/myconf/config/fzf/bin"
fi

eval "$(fzf --zsh)"
