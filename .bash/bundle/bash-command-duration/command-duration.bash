_start_timer() {
  if [[ $_TIMER_RESET -eq 1 ]]; then
    export _TIMER_TIMESTAMP=$(date "+%s")
    export _TIMER_RESET=0
  fi
}

_stop_timer() {
  if [[ -n "$_TIMER_TIMESTAMP" ]]; then
    export LAST_COMMAND_DURATION=$(expr `date "+%s"` - $_TIMER_TIMESTAMP)
  fi
}

_reset_timer() {
  export _TIMER_RESET=1
}

trap _start_timer DEBUG

export PROMPT_COMMAND="_stop_timer; ${PROMPT_COMMAND} _reset_timer"

