function curl-measure-response-time() {
  curl -o /dev/null -s -w %{time_total}\\n "$@"
}
