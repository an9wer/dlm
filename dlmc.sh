#!/bin/bash

DB=dlm.db

STATE_PENDING=1
STATE_RUNNING=2
STATE_DONE=3

usage() {
  echo "Usage: $(basename $0) [-il]"
  echo ""
  echo "  -i  interactive mode"
  echo "  -l  list running or pending tasks"
}

field_optional() {
  echo -ne "$*: "
}

field_required() {
  echo -ne "$*\e[31m*\e[m: "
}

db_create_task() {
  local link=$1
  local output=$2

  sqlite3 "$DB" "
    INSERT INTO dl_tasks (link, output, state)
    VALUES ('$link', '$output', $STATE_PENDING)
  "
}

db_list_tasks() {
  sqlite3 "$DB" "
    SELECT id, output, state
    FROM dl_tasks
    WHERE state = $STATE_PENDING or state = $STATE_RUNNING
  "
}


# main
while getopts "il" opt; do
  case $opt in
    i ) _opt_interaction=true ;;
    l ) _opt_list=true ;;
    ? ) usage; exit 1 ;;
  esac
done

if [ -n "$_opt_list" ]; then
  db_list_tasks
fi

if [ -n "$_opt_interaction" ]; then
  while true; do
    field_required "Download link"
    read link
    if [ -n "$link" ]; then
      break
    fi
  done

  field_optional "Saved filename"
  read output

  db_create_task "$link" "$output"
fi
