# https://wiki.archlinux.org/index.php/GnuPG#SSH_agent
# not in .pam_environment due to https://ro-che.info/articles/2016-11-08-pam_environment.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

# https://jlk.fjfi.cvut.cz/arch/manpages/man/gpg-agent.1
export GPG_TTY=$(tty)

if [ -x "$(which gpg-connect-agent)" ]; then
# start the gpg-agent if not running
if ! pgrep -x -u "$USER" gpg-agent >/dev/null 2>&1; then
    gpg-connect-agent updatestartuptty /bye > /dev/null
fi
fi
