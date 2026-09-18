#!/usr/bin/env zsh
# Mark a tmux window's name with the last command's exit status, so a window
# you aren't watching tells you it finished and how: name [✓] / name [✗].
#
#   source tmux-exit-flag.zsh     # .zshrc: install the prompt hooks
#   tmux-exit-flag.zsh clear @3   # tmux.conf: unmark a window once it's looked at
#   tmux-exit-flag.zsh clear-all  # escape hatch, if a mark ever gets stranded
#
# Best-effort by design: every failure path is silent.

# ---------------------------------------------------------------- sourced --
# No arguments means .zshrc is loading us: install the hooks and stop there.
# Skipped outside tmux, or if this file isn't runnable -- a half-synced
# checkout must not cost an error on every prompt.
if (( ! $# )); then
    _tmux_exit_flag_script=${${(%):-%x}:A}
    if [[ -n $TMUX && -x $_tmux_exit_flag_script ]]; then
        _tmux_exit_flag_before_command() { _tmux_exit_flag_command_ran=1 }
        _tmux_exit_flag_after_command() {
            local exit_code=$?
            [[ -n $_tmux_exit_flag_command_ran ]] || return
            unset _tmux_exit_flag_command_ran
            # Backgrounded so the prompt never waits on tmux, and silenced so
            # a script that vanishes mid-session can't print into the prompt.
            $_tmux_exit_flag_script mark $exit_code &>/dev/null &!
        }
        # Prepended so $? is still the command's own status, not a hook's.
        precmd_functions=(_tmux_exit_flag_after_command $precmd_functions)
        preexec_functions=(_tmux_exit_flag_before_command $preexec_functions)
    else
        unset _tmux_exit_flag_script
    fi
    return
fi

# --------------------------------------------------------------- executed --
OK_MARK=${ZSH_TMUX_MARK_OK:-✓}
FAIL_MARK=${ZSH_TMUX_MARK_FAIL:-✗}

case $1 in
    mark) exit_code=$2 window=$3 ;;
    clear) window=$2 ;;
    clear-all) ;;
    *) exit 0 ;;
esac
(( $+commands[tmux] )) || exit 0

tmux_quiet() { tmux "$@" 2>/dev/null }
window_option() { tmux_quiet show-options -wqv -t $window $1 }
window_name() { tmux_quiet display-message -p -t $window '#{window_name}' }
forget_original_name() {
    tmux_quiet set-option -wu -t $window @exit_flag_original_name
    tmux_quiet set-option -wu -t $window @exit_flag_auto_rename
}

# You are only really watching if the window is current, the session attached,
# AND the terminal has focus -- tmux.conf tracks that last one in
# @tmux_unfocused, because tmux cannot see which app macOS is showing.
user_is_watching() {
    local watching='#{&&:#{window_active},#{&&:#{session_attached},#{==:#{@tmux_unfocused},}}}'
    [[ $(tmux_quiet display-message -p -t $window $watching) == 1 ]]
}

# Strip a mark the name already carries, so a lost original name can never get
# baked in permanently.
strip_mark() {
    local name=${1%" [$OK_MARK]"}
    print -rn -- ${name%" [$FAIL_MARK]"}
}

mark_window() {
    local original_name=$(window_option @exit_flag_original_name)
    local current_name=$(window_name)
    [[ -n $current_name ]] || return
    # Claude Code owns this window's name right now; don't fight over it.
    [[ -z $original_name && -n $(window_option @claude_flag_original_name) ]] && return
    # Already watching it? Nothing to flag, and no focus change would ever
    # come along to unflag it.
    user_is_watching && return
    # A stored name that no longer matches means something else renamed the
    # window; adopt the new name rather than resurrect the old one.
    if [[ -z $original_name || $(strip_mark $current_name) != $original_name ]]; then
        original_name=$(strip_mark $current_name)
        # Record the name before touching it; a rename is otherwise unrecoverable.
        tmux_quiet set-option -w -t $window @exit_flag_original_name $original_name || return
        tmux_quiet set-option -w -t $window @exit_flag_auto_rename $(window_option automatic-rename)
    fi
    # Braces matter: "$original_name[...]" is subscript syntax in zsh.
    if (( exit_code == 0 )); then
        tmux_quiet rename-window -t $window "${original_name} [$OK_MARK]"
    else
        tmux_quiet rename-window -t $window "${original_name} [$FAIL_MARK]"
    fi
}

unmark_window() {
    local original_name=$(window_option @exit_flag_original_name)
    [[ -n $original_name ]] || return
    # Only take the name back if it's still ours; a window renamed since we
    # marked it belongs to whoever renamed it.
    if [[ $(strip_mark $(window_name)) == $original_name ]]; then
        tmux_quiet rename-window -t $window $original_name
        [[ $(window_option @exit_flag_auto_rename) == off ]] ||
            tmux_quiet set-option -w -t $window automatic-rename on
    fi
    forget_original_name
}

if [[ $1 == clear-all ]]; then
    for window in ${(f)"$(tmux_quiet list-windows -a -F '#{window_id}')"}; do unmark_window; done
    exit 0
fi

if [[ -z $window ]]; then
    [[ -n $TMUX && -n $TMUX_PANE ]] || exit 0
    window=$(tmux_quiet display-message -p -t $TMUX_PANE '#{window_id}')
fi
[[ $window == @<->* ]] || exit 0

if [[ $1 == mark ]]; then mark_window; else unmark_window; fi
exit 0
