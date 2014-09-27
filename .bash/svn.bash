function unsvn() {
  find $1 -name .svn -print0 | xargs -0 rm -rf
}

function svn-add-recursively() {
  svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add
}


