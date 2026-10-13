#! zsh
# IF NOT WORKING
#   1. TRY TO REMOVE ALL CACHE: `$ rm ~/.zcompdump*`
#   2. CHECK ENV: `$ echo $FPATH`

autoload -Uz compinit
# Only run the full compaudit security check once per day; skip it (-C) otherwise.
# (#q...) glob qualifiers need EXTENDED_GLOB, which is off by default here,
# so scope it locally rather than flipping it for the whole shell.
# REF: https://gist.github.com/ctechols/ca1035271ad134841284
() {
    setopt local_options extended_glob
    local dump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -n "$dump"(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # builtin completion [case insensitive]
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category

# APPROXIMATE MATCHE
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# PARTIAL MATCH
zstyle ':completion:*' matcher-list \
    'm:{[:lower:]}={[:upper:]}' \
    '+r:|[._-]=* r:|=*' \
    '+l:|=*'

# [ CONFLICT OPTIONS ]
    setopt auto_list # automatically list choices on ambiguous completion
    setopt auto_menu # automatically use menu completion
    setopt always_to_end # move cursor to end if word had one match
    # setopt correct_all # autocorrect commands

# [ COMPATIBLE WITH BASH ]
    # -> Fixing error: "zsh: no matches found"
    setopt no_nomatch

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/mc mc

