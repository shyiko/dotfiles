# @source http://brettterpstra.com/2014/05/14/up-fuzzy-navigation-up-a-directory-tree/

function _up() {
  local rx updir
  rx=$(ruby -e "print '$1'.gsub(/\s+/,'').split('').join('.*?')")
  updir=`echo $PWD | ruby -e "print STDIN.read.sub(/(.*\/${rx}[^\/]*\/).*/i,'\1')"`
  echo -n "$updir"
}

function _up_vcs() {
  local updir
  updir=$PWD
  while [ ! -d "$updir/.git" ] && [ ! -d "$updir/.hg" ] && [ ! -d "$updir/.svn" ]; do
    updir=${updir%/*}
    echo $updir
    if [ "$updir" = "" ]; then
      updir=$PWD
      break;
    fi
  done
  echo -n "$updir"
}

function up() {
  if [ $# -eq 0 ]; then
    cd $(_up_vcs)
  else
    cd $(_up "$@")
  fi
}
