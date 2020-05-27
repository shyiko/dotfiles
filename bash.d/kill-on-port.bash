function kill-on-port() {
  local signal=-15
  for port in "$@"; do
    if [[ ! "$port" =~ ^[0-9]+$ ]]; then
      signal="$port"
      continue
    fi
    local pid=$(lsof -P -iTCP:$port -sTCP:LISTEN | grep LISTEN | awk '{print $2}')
    if [ -n "$pid" ]; then
      echo "Killing pid=$pid (port=$port, signal=$signal)"
      kill $signal $pid
    fi
  done
}
