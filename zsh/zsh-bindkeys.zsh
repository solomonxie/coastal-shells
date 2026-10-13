#! zsh
# Important key bindings
bindkey -e  # Emacs style bindings!!
bindkey '^R' history-incremental-search-backward

bindkey '^p' up-line-or-search # Up arrow
bindkey '^n' down-line-or-search # Down arrow
# [autosuggestions] (history conflict with zsh hints, not recommanded)
# bindkey '^e' autosuggest-accept # [Essential] Ctrl+e to confirm hint
bindkey "^[[1;5D" backward-word  # ctrl-left
bindkey "^[[1;5C" forward-word  # ctrl-right
bindkey "^A" vi-beginning-of-line
bindkey "^e" vi-end-of-line
bindkey "^o" edit-command-line
bindkey "^k" backward-kill-line

# ^Conflict with fzf ---> (Allow ctrl-a ctrl-e to jump to the head/tail of the line)
# bindkey -e

# Ctrl-x Ctrl-e to edit command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# my_script_widget() {history 1000 |fzf}
# zle -N my_script_widget
# bindkey '^R' my_script_widget

# =========BACKWARD DELETE WORD============
# my-backward-delete-word() {
#     #REF: https://unix.stackexchange.com/questions/48577/modifying-the-zsh-shell-word-split
#     local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  # without /
#     zle backward-delete-word
# }
# zle -N my-backward-delete-word
# bindkey '^W' my-backward-delete-word
# REF: https://unix.stackexchange.com/questions/258656/how-can-i-have-two-keystrokes-to-delete-to-either-a-slash-or-a-word-in-zsh/258661#258661?newreg=88e4a4681c1c41e382f07df47688f34f
autoload -U select-word-style
select-word-style bash


# REF: https://newbedev.com/list-of-zsh-bindkey-commands
# LIST OF ALL "zle" commands to be binded
# $ zle -al
#   .accept-and-hold
# ...
