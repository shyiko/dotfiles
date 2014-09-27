function ip() {
  ifconfig | grep "inet " | awk '{ print $2 }'
  echo "external:$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')"
}

