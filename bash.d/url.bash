alias urlencode='python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read(), \"\"))"'
alias urldecode='python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read().strip()))"'
