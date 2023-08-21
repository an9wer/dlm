#!/bin/bash

DB=dlm.db

STATE_PENDING=1
STATE_RUNNING=2
STATE_DONE=3


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
  read -p "Download link: " link
  read -p "Saved filename (optional): " output

  db_create_task "$link" "$output"
fi
