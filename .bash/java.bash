function jar-show-manifest() {
  unzip -c $1 META-INF/MANIFEST.MF
}

function find-class() {
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
      fi
    fi
  done
}

