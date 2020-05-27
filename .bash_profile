# start X when user logs in on VT 1
# https://unix.stackexchange.com/questions/521037/what-is-the-environment-variable-xdg-vtnr
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# https://apple.stackexchange.com/questions/51036/what-is-the-difference-between-bash-profile-and-bashrc
. $HOME/.dotfiles/.bashrc
