# BASH prompt with https://github.com/romkatv/gitstatus support (optional).
#
# To preview:
# ```
# env -i HOME=$HOME TERM=$TERM bash --noprofile --norc
# source ~/.dotfiles/prompt.bash
#
# # if you have https://github.com/romkatv/gitstatus cloned at ~/.gitstatus
# source ~/.gitstatus/gitstatus.plugin.sh
# gitstatus_start -s -1 -u -1 -c -1 -d -1
# ````
#
# Options:
# - `PROMT_BASH_PRINT_EXECUTED_AT=1` before source'ing prompt.bash to enable
#   "# executed at HH:MM:SS" output.

# do nothing if not running interactively
[ -z "$PS1" ] && return

# these two are not strictly required
if [[ "$TERM" == "" ]]; then
    # https://www.commandlinux.com/man-page/man7/term.7.html
    echo "prompt.bash: TERM env variable must be set \
(e.g. export TERM=xterm-color)" >&2
    return
fi
if [[ "$HOME" == "" ]]; then
    # \w is printed as /home/<username>/path and not ~/path if $HOME isn't set
    echo "prompt.bash: HOME env variable must be set \
(e.g. export HOME=/home/<username>)" >&2
    return
fi

# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
_prompt_bash__PS_USER="\u"
_prompt_bash__PS_HOST="\h"
_prompt_bash__PS_PWD="\w"
_prompt_bash__PS_PROMPT="\\$"
_prompt_bash__PS_TIME="\t"

_prompt_bash__GIT_STAGED_SYMBOL='±'
_prompt_bash__GIT_CONFLICTED_SYMBOL='⚡'
_prompt_bash__GIT_UNSTAGED_SYMBOL='…'
_prompt_bash__GIT_UNTRACKED_SYMBOL='?'
_prompt_bash__GIT_COMMITS_AHEAD_SYMBOL='⇡'
_prompt_bash__GIT_COMMITS_BEHIND_SYMBOL='⇣'

_prompt_bash__PRINTING_OFF="\["
_prompt_bash__PRINTING_ON="\]"
_prompt_bash__NO_COLOR="\e[00m"

_prompt_bash__FG_BLACK="\e[30m"
_prompt_bash__FG_WHITE="\e[97m"

_prompt_bash__FG_YELLOW="\e[33m"
_prompt_bash__FG_ORANGE="\e[33m"
_prompt_bash__FG_RED="\e[31m"
_prompt_bash__FG_MAGENTA="\e[35m"
_prompt_bash__FG_VIOLET="\e[35m"
_prompt_bash__FG_BLUE="\e[34m"
_prompt_bash__FG_CYAN="\e[36m"
_prompt_bash__FG_GREEN="\e[32m"

_prompt_bash__BG_YELLOW="\e[43m"
_prompt_bash__BG_ORANGE="\e[43m"
_prompt_bash__BG_RED="\e[41m"
_prompt_bash__BG_MAGENTA="\e[45m"
_prompt_bash__BG_VIOLET="\e[45m"
_prompt_bash__BG_BLUE="\e[44m"
_prompt_bash__BG_CYAN="\e[46m"
_prompt_bash__BG_GREEN="\e[42m"

# `git` location.
_prompt_bash__GIT=
if [ -x "$(which git)" ]; then
   _prompt_bash__GIT="git"
fi

_prompt_bash__git_status() {
    # Use `gitstatusd` to speed up `git status` if present.
    # https://github.com/romkatv/gitstatus
    VCS_STATUS_RESULT=
    if [[ "$GITSTATUS_DAEMON_PID" != "" ]]; then
        # Set VCS_* (https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.sh)
        gitstatus_query
    fi
    # Use regulat `git` as a fallback.
    if [[
        "$_prompt_bash__GIT" != "" &&
        "$VCS_STATUS_RESULT" != "ok-sync" &&
        "$VCS_STATUS_RESULT" != "norepo-sync"
    ]]; then
        local VCS_STATUS_LOCAL_BRANCH="$(
            $_prompt_bash__GIT symbolic-ref --short HEAD 2>/dev/null || # branch name
            $_prompt_bash__GIT describe --tags --exact-match 2>/dev/null # tag name
        )"
        if [[ "$VCS_STATUS_LOCAL_BRANCH" == "" ]]; then
            local VCS_STATUS_COMMIT="$(
                $_prompt_bash__GIT rev-parse --short HEAD 2>/dev/null # commit hash
            )"
        fi
        # e.g.
        #
        #   ## master...origin/master [behind 7]
        #    M modified_file
        #   D  deleted_file
        #   MM unstaged_modified_file
        #   ?? untracked_file
        #
        local git_status="$($_prompt_bash__GIT status --porcelain --branch 2>/dev/null)"
        local VCS_STATUS_NUM_STAGED=$(
            echo "$git_status" |
            grep -v '^##' |
            grep -c '^[MADRC]'
        )
        local VCS_STATUS_NUM_CONFLICTED=$(
            echo "$git_status" |
            grep -v '^##' |
            grep -c '^U\|^.U'
        )
        local VCS_STATUS_NUM_UNSTAGED=$(
            echo "$git_status" |
            grep -v '^##' |
            grep -c '^[^U][MADRC]'
        )
        local VCS_STATUS_NUM_UNTRACKED=$(
            echo "$git_status" |
            grep -v '^##' |
            grep -c '^[?][?]'
        )
        local VCS_STATUS_COMMITS_AHEAD="$(
            echo "$git_status" |
            grep '^##' |
            grep -o '\[.\+\]$' |
            grep -o 'ahead [[:digit:]]\+' |
            grep -o '[[:digit:]]\+' || echo "0"
        )"
        local VCS_STATUS_COMMITS_BEHIND="$(
            echo "$git_status" |
            grep '^##' |
            grep -o '\[.\+\]$' |
            grep -o 'behind [[:digit:]]\+' |
            grep -o '[[:digit:]]\+' || echo "0"
        )"
    fi

    if [[
        "$VCS_STATUS_LOCAL_BRANCH" == "" &&
        "$VCS_STATUS_COMMIT" == ""
    ]]; then
        return
    fi

    local line=()
    if [[ "$VCS_STATUS_LOCAL_BRANCH" != "" ]]; then
        line+=("$VCS_STATUS_LOCAL_BRANCH")
    else
        line+=("@$VCS_STATUS_COMMIT")
    fi
    [[ "$VCS_STATUS_NUM_STAGED" != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_STAGED_SYMBOL"
            "$VCS_STATUS_NUM_STAGED"
        )
    [[ "$VCS_STATUS_NUM_CONFLICTED" != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_CONFLICTED_SYMBOL"
            "$VCS_STATUS_NUM_CONFLICTED"
        )
    [[ "$VCS_STATUS_NUM_UNSTAGED"  != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_UNSTAGED_SYMBOL"
            "$VCS_STATUS_NUM_UNSTAGED"
        )
    [[ "$VCS_STATUS_NUM_UNTRACKED" != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_UNTRACKED_SYMBOL"
            "$VCS_STATUS_NUM_UNTRACKED"
        )
    [[ "$VCS_STATUS_COMMITS_AHEAD" != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_COMMITS_AHEAD_SYMBOL"
            "$VCS_STATUS_COMMITS_AHEAD"
        )
    [[ "$VCS_STATUS_COMMITS_BEHIND" != 0 ]] &&
        line+=(
            " $_prompt_bash__GIT_COMMITS_BEHIND_SYMBOL"
            "$VCS_STATUS_COMMITS_BEHIND"
        )
    _prompt_bash__join "${line[@]}"
}

# This function is evaluated as part of PS0 and as such cannot modify
# the env (e.g. cannot export vars).
_prompt_bash__before_command_isolated() {
    echo -n $SECONDS >$_prompt_bash__CMD_EXECUTED_AT
}

# This one on the other hand can.
_prompt_bash__after_command() {
   	local exit_code=$?

	local cmd_stat=""
	if [[ "$exit_code" != "0" ]]; then
	    cmd_stat+=", exit code: $exit_code"
	fi

    local start="$(cat $_prompt_bash__CMD_EXECUTED_AT 2>/dev/null)"
    echo > $_prompt_bash__CMD_EXECUTED_AT # truncate
    if [[ "$start" != "0" && "$start" != "" ]]; then
        local delta=$((SECONDS-start))
        if [[ "$delta" != "0" ]]; then
            cmd_stat+=", elapsed time: ${delta}s"
        fi
    fi

    if [[ "$cmd_stat" != "" ]]; then
        local color=$_prompt_bash__FG_GREEN
	    if [[ "$exit_code" != "0" ]]; then
		    color=$_prompt_bash__FG_RED
	    fi
	    cmd_stat="$(_prompt_bash__color "$color")# ${cmd_stat/, /}$(_prompt_bash__color_off)\n"
	fi

    local dir_stat
	local git_info=$(_prompt_bash__git_status)
    if [[ "$git_info" != "" ]]; then
        local color=$_prompt_bash__FG_GREEN
        if [[ "$git_info" == *" $_prompt_bash__GIT_STAGED_SYMBOL"* ]]; then
            color=$_prompt_bash__FG_YELLOW
        fi
        dir_stat=" $(_prompt_bash__color "$color")$git_info$(_prompt_bash__color_off)"
    fi

    local ps1_arr=(
        "$cmd_stat"
        # 1st line
        $(_prompt_bash__color "$_prompt_bash__BG_BLUE" "$_prompt_bash__FG_BLACK")
        " $_prompt_bash__PS_USER@$_prompt_bash__PS_HOST "
        $(_prompt_bash__color_off)
        $(_prompt_bash__color "$_prompt_bash__FG_BLUE")
        " $_prompt_bash__PS_PWD"
        $(_prompt_bash__color_off)
        "$dir_stat"
        "\n"
        # 2nd line
        "$_prompt_bash__PS_PROMPT "
    )
    PS1=$(_prompt_bash__join "${ps1_arr[@]}")
}

_prompt_bash__color() {
    _prompt_bash__join "$_prompt_bash__PRINTING_OFF" "$@" "$_prompt_bash__PRINTING_ON"
}

_prompt_bash__color_off() {
    echo -n "$_prompt_bash__PRINTING_OFF$_prompt_bash__NO_COLOR$_prompt_bash__PRINTING_ON"
}

_prompt_bash__join() (
    IFS=; echo -n "$*"
)

if [[ "$_prompt_bash__CMD_EXECUTED_AT" == "" ]]; then
    _prompt_bash__CMD_EXECUTED_AT=$(mktemp -t _promp_bash.XXXXXX)
    trap "rm -f $_prompt_bash__CMD_EXECUTED_AT" EXIT
fi

# <type command> (0 or more PS2s (only used for multi-line commands)) <enter>
# PS0 (not evaluated if you hit enter, tab, etc)
# <exec command>
# PROMPT_COMMAND
# PS1

_prompt_bash__ps0_arr=()
if [[ "$PROMT_BASH_PRINT_EXECUTED_AT" == "1" ]]; then
    _prompt_bash__ps0_arr+=(
        $(_prompt_bash__color "$_prompt_bash__FG_BLUE")
        "# executed at $_prompt_bash__PS_TIME"
        $(_prompt_bash__color_off)
        "\n"
    )
fi
_prompt_bash__ps0_arr+=(
    "\$(_prompt_bash__before_command_isolated)"
)
PS0=$(_prompt_bash__join "${_prompt_bash__ps0_arr[@]}")
unset _prompt_bash__ps0_arr
PS2= # > by default
PROMPT_COMMAND=_prompt_bash__after_command
