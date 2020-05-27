eval "$(fasd --init auto)"

# https://github.com/clvv/fasd/pull/72
_fasd_prompt_func () {
    local exit_code=$?
    eval "fasd --proc $(fasd --sanitize $(history 1 | sed "s/^[ ]*[0-9]*[ ]*//"))" >> "/dev/null" 2>&1
    return $exit_code
}

