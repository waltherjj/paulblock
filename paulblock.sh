#!/usr/bin/env bash
# More safety, by turning some bugs into errors.
set -o errexit -o pipefail -o noclobber -o nounset

if [[ $EUID -ne 0 ]]; then
   echo "Bitte mit sudo ausführen: \"sudo ./paulblock.sh\"" 
   exit 1
fi

pass=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--restore) pass="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

p=$(echo -n date | sha256sum | cut -d " " -f1)

if [[ $pass = $p ]]; then
  if test -e "/etc/hosts.bkp.paulblock"; then
    mv /etc/hosts.bkp.paulblock /etc/hosts;
    echo "Blacklist gelöscht.";
  else
    echo "Keine Blacklist gefunden."
  fi
  exit 0;
fi

echo "### Paulblock 0.1 by JW ###"
echo "Hallo Paul! Gib die Seite ein, die blockiert werden soll und bestätige mit <Enter>."
echo "Bitte beachten: wenn du z.b. \"nba.com\" blockierst, geht \"www.nba.com\" immer noch, also immer \"www.nba.com\" UND \"nba.com\" blockieren."
echo "Wenn du fertig bist gibst, beendest du das Programm mit <Strg+C>."
echo ""

while true; do
  read url

  cp -n /etc/hosts /etc/hosts.bkp.paulblock;

  echo "127.0.0.1" $url >> /etc/hosts

  echo $url "wurde blockiert!"
done
