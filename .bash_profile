# java
export JAVA_HOME=/home/oss/jdk1.6.0_26
export PATH=$JAVA_HOME/bin:$PATH
# maven
export M2_HOME=/home/oss/apache-maven-3.0.3
export PATH=$M2_HOME/bin:$PATH
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=256m"
# postgresql
export PGHOST=localhost
alias psql='psql -U postgres'
# ant
export PATH=/home/oss/apache-ant-1.8.2/bin:$PATH

alias subl='/home/oss/sublime-text-2/sublime_text'
alias ebp='nano ~/.bash_profile'
alias dotfiles-show-changes="diff -aur /home/oss/github/dotfiles /home/shyiko | grep -v 'Only in'"

# oss
alias cdo='cd /home/oss'

# cogniance
alias cdc='cd /home/j2dev/cogniance'
alias remind-sudo-passwordless-mode='string="Defaults:sshyiko !requiretty \nDefaults:sshyiko visiblepw \nDefaults:sshyiko !authenticate"; echo -e $string; unset string'

function jboss-start() {
        cd /home/j2dev/cogniance/jboss510ga/bin
        ./run.sh -b 0.0.0.0
}

function jboss-kill() {
        jkill jboss
}

function jboss-clean() {
        rm -v /home/j2dev/cogniance/jboss510ga/server/default/deploy/aim-*.*ar
}
