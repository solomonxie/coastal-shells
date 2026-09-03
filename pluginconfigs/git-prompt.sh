#REF: https://github.com/woefe/git-prompt.zsh
if [ ! -e ~/.zsh_plugins/git-prompt/ ];then
    git clone https://github.com/woefe/git-prompt.zsh ~/.zsh_plugins/git-prompt
fi
source ~/.zsh_plugins/git-prompt/git-prompt.zsh
# source ~/.zsh_plugins/git-prompt/examples/multiline.zsh

#REF: https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors
#REF: https://www.vertex42.com/ExcelTips/unicode-symbols.html

# CUSTOMIZATION
# source ~/.zsh_plugins/git-prompt/examples/compact.zsh
ZSH_GIT_PROMPT_SHOW_STASH=1
ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"  # symbol|full|no
ZSH_THEME_GIT_PROMPT_PREFIX=" ⎇ "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[cyan]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} √"
ZSH_THEME_GIT_PROMPT_TAGS_PREFIX="🏷 "
ZSH_THEME_GIT_PROMPT_TAGS_SUFFIX=""
ZSH_THEME_GIT_PROMPT_TAG="%{$fg_bold[magenta]%}"

_ZSH_FULL_DIR='%'
_ZSH_CURRENT_DIR='%.'
_ZSH_COMMAND_PREFIX='>>'  # ❯ | $|> | » | >>

# venv's own activate script double-parens PS1 (e.g. "((venv) )") on
# Python 3.12+, since it already wraps VIRTUAL_ENV_PROMPT in parens itself.
# Disable its PS1 edit and show our own single-paren segment instead.
export VIRTUAL_ENV_DISABLE_PROMPT=1
venvprompt() {
    [ -n "$VIRTUAL_ENV" ] && echo "(${VIRTUAL_ENV:t}) "
}

# PROMPT='%B%40<..<%~%b$(gitprompt)'
PROMPT='%F{yellow}$(venvprompt)%{$fg_bold[cyan]%}${_ZSH_CURRENT_DIR}%b%F{white}$(gitprompt) '
PROMPT+='%(?.%(!.%F{white}❯%F{yellow}❯%F{red}.%F{green})${_ZSH_COMMAND_PREFIX}%f.%F{red}${_ZSH_COMMAND_PREFIX}%f) '
RPROMPT=''
