function ip-addr-external() {
  curl -sSL checkip.dyndns.org | grep -Eo '[0-9\.]+'
}
