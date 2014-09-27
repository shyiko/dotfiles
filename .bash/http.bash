function http-intercept() {
  local interface=${1:-lo0}
  local port=${2:-8080}
  sudo ngrep -q -d ${interface} -W byline -t '^(OPTIONS|GET|HEAD|POST|PUT|DELETE|TRACE|CONNECT) ' port ${port}
}

function http-measure-response-time() {
  curl -o /dev/null -s -w %{time_total}\\n "$@"
}

