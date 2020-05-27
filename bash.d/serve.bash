# alternative that supports TLS, etc - https://github.com/syntaqx/serve
function serve() {
    python3 -m http.server "$@"
}