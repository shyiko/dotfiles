alias sudo='sudo ' # allow aliases to be sudo'ed

function remind-me-sudo-passwordless-mode() {
    echo $'
Defaults:username !requiretty
Defaults:username visiblepw
Defaults:username !authenticate
'
}
