THIRDPARTY=~/Development/thirdparty

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

JVM=/Library/Java/JavaVirtualMachines
export JDK6_HOME=$JVM/1.6.0_35-b10-428.jdk/Contents/Home
export JDK7_HOME=$JVM/jdk1.7.0_17.jdk/Contents/Home
export JDK8_HOME=$JVM/jdk1.8.0_20.jdk/Contents/Home
export JAVA_HOME=$JDK6_HOME
export PATH=$JAVA_HOME/bin:$PATH

export M2_HOME=$THIRDPARTY/apache-maven-3.0.4
export PATH=$M2_HOME/bin:$PATH
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=256m"

export PATH=$THIRDPARTY/apache-ant-1.8.4/bin:$PATH

export PATH=$THIRDPARTY/apache-cassandra-1.2.1/bin:$PATH

export PGHOST=localhost
export PGUSER=postgres

export PATH=$THIRDPARTY/terminal-notifier_1.4.2/terminal-notifier.app/Contents/MacOS:$PATH

[ -s ~/.nvm/nvm.sh ] && . ~/.nvm/nvm.sh

export PATH="/usr/local/heroku/bin:$PATH"

[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

