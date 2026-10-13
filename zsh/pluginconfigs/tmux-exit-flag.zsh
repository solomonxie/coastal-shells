#!/usr/bin/env zsh
# Mark a tmux window's name with how its last command ended, so a window you
# aren't watching speaks for itself: name (✓) ok / name (✗) failed.
#
#   source tmux-exit-flag.zsh     # .zshrc: install the prompt hooks
#   tmux-exit-flag.zsh seen @3    # tmux.conf: drop the mark once it's looked at
#   tmux-exit-flag.zsh clear @3   # same, from anywhere
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
        # Agent CLIs run for the whole session and track their own state.
        (( ${+ZSH_TMUX_MARK_IGNORE} )) || ZSH_TMUX_MARK_IGNORE=(claude codex)
        _tmux_exit_flag_before_command() {
            # $2 is the command line with aliases expanded.
            (( ${ZSH_TMUX_MARK_IGNORE[(Ie)${${(z)2}[1]:t}]} )) && return
            _tmux_exit_flag_command_ran=1
        }
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
    mark)
        exit_code=$2 window=$3
        (( exit_code == 0 )) && mark=$OK_MARK || mark=$FAIL_MARK
        ;;
    seen | clear) window=$2 ;;
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
    local name=${1%" ($OK_MARK)"}
    print -rn -- ${name%" ($FAIL_MARK)"}
}

mark_window() {
    local original_name=$(window_option @exit_flag_original_name)
    local current_name=$(window_name)
    [[ -n $current_name ]] || return
    # A mark on a window you are already watching would say nothing you can't
    # see, and no focus change would ever come along to unflag it.
    if user_is_watching; then
        unmark_window
        return
    fi
    # A stored name that no longer matches means something else renamed the
    # window; adopt the new name rather than resurrect the old one.
    if [[ -z $original_name || $(strip_mark $current_name) != $original_name ]]; then
        original_name=$(strip_mark $current_name)
        # Record the name before touching it; a rename is otherwise unrecoverable.
        tmux_quiet set-option -w -t $window @exit_flag_original_name $original_name || return
        tmux_quiet set-option -w -t $window @exit_flag_auto_rename $(window_option automatic-rename)
    fi
    # Braces matter: "$original_name[...]" is subscript syntax in zsh.
    tmux_quiet rename-window -t $window "${original_name} (${mark})"
}

unmark_window() {
    local original_name=$(window_option @exit_flag_original_name)
    [[ -n $original_name ]] || return
    local current_name=$(window_name)
    # Only take the name back if it's still ours; a window renamed since we
    # marked it belongs to whoever renamed it.
    if [[ $(strip_mark $current_name) == $original_name ]]; then
        tmux_quiet rename-window -t $window $original_name
        # Put automatic-rename back exactly as it was. rename-window just set it
        # off on the window; empty means it was inherited, so unset to inherit
        # again -- forcing it on would override a global `off`.
        case $(window_option @exit_flag_auto_rename) in
            on) tmux_quiet set-option -w -t $window automatic-rename on ;;
            '') tmux_quiet set-option -wu -t $window automatic-rename ;;
        esac
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

case $1 in
    seen | clear) unmark_window ;;
    *) mark_window ;;
esac
exit 0
