#! zsh
######################################################
#                  _________  _   _                  #
#                 |__  / ___|| | | |                 #
#                   / /\___ \| |_| |                 #
#                  / /_ ___) |  _  |                 #
#                 /____|____/|_| |_|                 #
#                                                    #
######################################################

#######################################################################
#                      IMPORT MODULIZED SETTINGS                      #
#######################################################################
# if [[ "$0" =~ "zsh" ]]; then  # >>> PLUGINS >>>
source ~/.config/zsh/zsh-performance.sh
source ~/.config/zsh/zsh-bindkeys.zsh
source ~/.config/zsh/zsh-completion.sh

# PLUGINS
source ~/.config/zsh/pluginconfigs/zsh-syntax-highlighting.sh  # -> 16ms
source ~/.config/zsh/pluginconfigs/zsh-autosuggestions.sh  # -> 50ms
# source ~/.config/zsh/pluginconfigs/zsh-autocomplete.sh  #1100ms -> SUPER SLOW & UGLY
source ~/.config/zsh/pluginconfigs/zsh-cmd-time.sh

# UTILS
# source ~/.config/zsh/pluginconfigs/autojump.sh
# source ~/.config/zsh/pluginconfigs/broot.sh

# THEMES
# source ~/.config/zsh/ohmyzsh-settings.sh
# source ~/.config/zsh/pluginconfigs/pure-zsh.sh
# source ~/.config/zsh/pluginconfigs/myminimalist-theme.sh
# source ~/.config/zsh/pluginconfigs/zsh-theme-minimal.sh
# source ~/.config/zsh/pluginconfigs/zsh-theme-powerlevel10k.sh
source ~/.config/zsh/pluginconfigs/git-prompt.sh  # BLAZING FAST!!

# Mark the tmux window with what the shell is doing ((✓)/(✗))
source ~/.config/zsh/pluginconfigs/tmux-exit-flag.zsh
# fi

source ~/.config/zsh/bash-alias.sh
source ~/.config/zsh/bash-functions.sh
source ~/.config/zsh/zsh-envutils.sh

# alias alias=:  # Avoid override by other installations

#######################################################################
#                          GENERAL SETTINGS                           #
#######################################################################
# Vi mode
# set editing-mode vi

# Default Editor (Ctrl-x plus Ctrl-e to pop editor for current shell command)
# [[ -e $(command -v nvim) ]] && export EDITOR=nvim || export EDITOR=vim
export EDITOR=nvim || export EDITOR=vim
alias vim="nvim" && alias vimdiff="nvim -d"

# set -o vi

# Get rid of "you have a mail" from crontab
MAILCHECK=0

# History
export HISTFILE=~/.bash_history
export HISTSIZE=50000
export SAVEHIST=10000
export HISTTIMEFORMAT=''  # '%F %T: '
setopt appendhistory
setopt extendedhistory
setopt sharehistory
setopt incappendhistory

# User-specified hosts (not working at the moment)
# set HOSTALIASES=~/hosts

# Set Default Title (Useful for Tmux pane-border title)
# printf "\033]0;%s\a" "TITLE"  #THIS JEPERDIZE SOME PROGRAMS (etc., ANSIBLE)


#######################################################################
#                             GENERAL UI                              #
#######################################################################
# REF: https://geoff.greer.fm/lscolors/
# export LSCOLORS='BXfxcxdxbxegedabagacad'  # BSD
export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'  # LINUX

#######################################################################
#                    PATH / ENVIRONMENT VARIABLES                     #
#######################################################################
# Some would be imported here by other programms automatically
# etc., cat 'expot path=...' > ~/.zshrc

# LOCAL LANGUAGE:
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# =========LOCALBIN=========
export PATH="/usr/bin:/usr/local/bin:/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"  # Curl newer version
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
# =====GNU BIN===============
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# ===========Clang=================
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

# =====MISC===============
export MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

export TMUX_PLUGIN_MANAGER_PATH='~/.tmux/plugins'

export WEZTERM_CONFIG_DIR="${HOME}/.config/wezterm"
export WEZTERM_CONFIG_FILE="${HOME}/.config/wezterm/wezterm.lua"

# Clang for building packages (requires brew install openssl)
# export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# ^ NOTE: DO NOT ENALBE THESE IN PERSISTENT DOTFILES, WILL CAUSE SOME OTHER BUILDING FAILURES

# =========OVERRIDES===========
# Machine-wise overrides: version-pinned runtimes, app paths, prompt tweaks (bash-compatible)
[ -f ~/.bashrc-local ] || touch ~/.bashrc-local
source ~/.bashrc-local || true
# Project-wise overrides
[ -f ~/.global.env ] || touch ~/.global.env
source ~/.global.env >>/dev/null 2>&1

# BETTER TO BE AT THE BOTTOM
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 2>/dev/null  # silences benign "can't change option: zle" from fzf's option save/restore
# [ -f ~/.asdf/asdf.sh ] && source ~/.asdf/asdf.sh  # will mess up Vim environment
