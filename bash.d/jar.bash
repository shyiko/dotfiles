function jar-show-manifest() {
  unzip -c $1 META-INF/MANIFEST.MF
}

function jar-bin() {
  cat <(printf '#!/bin/sh\nexec java -jar \"$0\" \"$@\"\n\n') $1 > $1.bin
  chmod +x $1.bin
}
