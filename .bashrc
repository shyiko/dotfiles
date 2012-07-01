# do nothing if not running interactively
[ -z "$PS1" ] && return

PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

# enable case-insensitive globbing
shopt -s nocaseglob
# do not override bash history file (append to it)
shopt -s histappend
# autocorrect typos during cd calls
shopt -s cdspell
# autocorrect types during completion
shopt -s dirspell
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# put multi-line commands onto one line of history
shopt -s cmdhist

# make less more friendly for non-text input files, see lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export EDITOR="nano"
export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export HISTSIZE=4096
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
export PATH=~/.bin:$PATH

eval "$(dircolors -b)"
# colorize prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

. /etc/bash_completion
if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
fi

eval "$(fasd --init auto)"
alias n='f -e nano'
_fasd_bash_hook_cmd_complete n

alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"
alias cls='clear'
alias his='history'
alias q="exit"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto -i'
alias nano="nano -c"

# copy std output to clipboard
# pre-requirement: sudo apt-get install xsel
alias clip='xsel -b'

alias whois="whois -h whois-servers.net"

# notify upon completion (e.g. sleep 3; nfy)
alias nfy='notify-send "Completed" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*nfy$//'\'')"'

if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi    

# create a new directory and cd into it
function md() {
	mkdir -p "$@" && cd "$@"
}

function mvnfy() {
    mvn $@
    if [ $? -gt 0 ]
    then
        notify-send -i /usr/share/icons/Humanity/status/64/dialog-warning.svg "Maven" "Build failed."
    else
        notify-send -i /usr/share/icons/Humanity/actions/64/gtk-info.svg "Maven" "Build succeeded."
    fi
}

function findclass() {
    local directory=$1
    local class_name=$2
    find $directory -name '*.[jwes]ar' | while read line; do
        grep -q $class_name "$line";
        if [ $? -eq 0 ]; then
            echo $line
            local references=$(jar tvf "$line" | grep $class_name);
            if [ -n "$references" ]; then
                echo "$LINE";
                echo "$references";
                echo;
            fi;
        fi;
    done
}

function server() {
	local port="${1:-8080}"
	echo "Mapping $(pwd) to http://localhost:${port}"
	# use `text/plain` as default Content-Type instead of `application/octet-stream` and serve everything as UTF-8
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

function sniff() {
    local interface=${1:-lo}
    local port=${2:-8080}
    sudo ngrep -q -d ${interface} -W byline -t '^(GET|POST) ' port ${port}
}

function test-http-compression() {
	encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}

function gurl() {
	curl -sH "Accept-Encoding: gzip" "$@" | gunzip
}

function extract() {
  if [ $# -ne 1 ]
  then
    echo "Error: No file specified."
    return 1
  fi
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2 | *.tar.gz | *.tar | *.tbz2 | *.tgz) tar xvf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.zip | *.jar) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.7z) 7z x $1 ;;
			*) echo "'$1' cannot be extracted via extract" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function ips() {
    ifconfig | grep "inet " | awk '{ print $2 }'
    echo "external-addr:$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')"
}

# sudo apt-get install markdown realpath
function markdown-to-html() {
    markdown $1 > $1.html
    realpath $1.html | clip
}

function quiet() {
    $* &> /dev/null &
}

function backup() {
    local filename=$1
    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp ${filename} ${filename}_${timestamp}
}

function git-ignore-locally() {
    echo "$1" >> .git/info/exclude
}

function git-remove-missing-files() {
    git ls-files -d -z | xargs -0 git update-index --remove
}

function jar-show-manifest() {
    unzip -c $1 META-INF/MANIFEST.MF
}

function svn-strip-off() {
    find $1 -name .svn -print0 | xargs -0 rm -rf
}

function svn-add-recursively() {
    svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add
}

# kills java application using argument as a name or a port number
# examples: "jkill jboss", "jkill 8080"
function jkill() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] ; then
        kill -9 $(jps -l | grep $port | cut -d\  -f1)
        return
    fi
    local input=`netstat -lnp | grep ${port}`
    if [[ "$input" =~ ([0-9])+[/]java ]]; then
	    local id=`echo $BASH_REMATCH | sed s/[/]java//`
	    kill -9 $id
	    echo "Killed $id"
    else
	    echo "Unable to determine java application bound to ${port}"
    fi
}

# evaluate math function
# examples: "_ 1024*17/3.0"
function _() {
    echo "$1" | bc;
}
