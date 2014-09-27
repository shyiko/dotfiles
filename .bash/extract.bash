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

