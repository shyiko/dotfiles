# do nothing if not running interactively
[ -z "$PS1" ] && return

# enable case-insensitive globbing
shopt -s nocaseglob
# do not override bash history file (append to it)
shopt -s histappend
# autocorrect typos during cd calls
shopt -s cdspell
# autocorrect types during completion
# shopt -s dirspell
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# put multi-line commands onto one line of history
shopt -s cmdhist
# turn off history expansion
set +o histexpand

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

# colorize prompt
PS1='\[\e[0;33m\]\u@\h(\A):\W\$\[\e[m\] '

if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
fi

if [ -f ~/.z_sh ]; then
    . ~/.z_sh
fi

alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"
alias cls='clear'
alias his='history'
alias q="exit"
alias ls='ls -G'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto -i'
alias hgrep='history | grep'
alias nano="nano -c"
alias whois="whois -h whois-servers.net"

alias subl='/Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2'
alias ebp='nano ~/.bash_profile'

# notify (e.g. sleep 3; nfy done sleeping)
# relies on "sudo gem install terminal-notifier"
# usage: "some_long_running_task; nfy done, exit code = $?"
function nfy() {
    local message="$@"
    terminal-notifier -message "$message"
}

if [ -f ~/.env ]; then
    . ~/.env
fi    

# create a new directory and cd into it
function md() {
	mkdir -p "$@" && cd "$@"
}

function mvnfy() {
    mvn $@
    if [ $? -gt 0 ]
    then
        terminal-notifier -title "Maven" -message "Build failed."
    else
        terminal-notifier -title "Maven" -message "Build succeeded."
    fi
}

# usage: find-java-class . ClassName
function find-java-class() {
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
    local interface=${1:-lo0}
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

function ip() {
    ifconfig | grep "inet " | awk '{ print $2 }'
    echo "external-addr:$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')"
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

# usage: kill-java jboss
function kill-java() {
    local name=$1
    local signal=${2:--9}
    local pid=$(jps -l | grep $name | cut -d\  -f1)
    if [ -n "$pid" ]; then
        kill $signal $pid
    fi
}

# usage: kill-on-port 8080
function kill-on-port() {
    local port=$1
    local signal=${2:--9}
    local pid=$(lsof -iTCP:$port -sTCP:LISTEN -Fp | cut -dp -f2)
    if [ -n "$pid" ]; then
        kill $signal $pid
    fi
}

alias ipfw-show='sudo ipfw show'
alias ipfw-80-to-8000='sudo ipfw add 100 fwd 127.0.0.1,8000 tcp from any to any 80 in'
alias ipfw-reset='sudo ipfw flush'

function mysql_rename_database() {
    local mysql="mysql -h$1 -u$2 -p$3"
    local sourcedb=$4
    local targetdb=$5
    $mysql -e "CREATE DATABASE $targetdb"
    local tables=$($mysql -N -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='$sourcedb'")
    for table in $tables; do
      $mysql -e "RENAME TABLE $sourcedb.$table to $targetdb.$table";
    done;
    $mysql -e "DROP DATABASE $sourcedb"
}
