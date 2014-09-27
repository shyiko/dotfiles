function kill-on-port() {
  local signal=$1
  local port=$2    
  local pid=$(lsof -sTCP:LISTEN -iTCP:$port -Fp | cut -dp -f2)
  if [ -n "$pid" ]; then
    kill $signal $pid
  fi
}
