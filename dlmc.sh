#!/bin/bash

DB=dlm.db

STATE_PENDING=1
STATE_RUNNING=2
STATE_DONE=3

REQUIRED_MARK="\e[5m\e[31m*\e[0m"


db_create_task() {
  local link=$1
  local output=$2

  sqlite3 "$DB" "
    INSERT INTO dl_tasks (link, output, state)
    VALUES ('$link', '$output', $STATE_PENDING)
  "
}


# main
while (( ${#@} > 0 )); do
  case $1 in
    -i|--interact ) INTERACT=true ;;
  esac
  shift
done

if [[ -n $INTERACT ]]; then
  while true; do
    echo -ne "Download link$REQUIRED_MARK: "
    read link
    if [[ -n $link ]]; then
      break
    fi
  done

  echo -ne "Saved filename: "
  read output

  db_create_task "$link" "$output"
fi