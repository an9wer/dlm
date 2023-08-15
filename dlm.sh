#!/bin/bash

DB=dlm.db

STATE_PENDING=1
STATE_RUNNING=2
STATE_DONE=3


# initialize database
sqlite3 "$DB" '
  CREATE TABLE IF NOT EXISTS dl_tasks (
    id INTEGER PRIMARY KEY,
    link TEXT NOT NULL,
    output TEXT,
    state  INTEGER NOT NULL
)'


# main
while inotifywait -q -e modify -e attrib "$DB"; do
  sleep 2  # TODO: db locked

  while true; do
    task=$(sqlite3 "$DB" "
      SELECT id, link, output
      FROM dl_tasks
      WHERE state = $STATE_PENDING or state = $STATE_RUNNING
      LIMIT 1
    ")
    declare -p task

    if [[ -z $task ]]; then
      break
    fi

    task_id=$(echo $task | awk -F '|' '{ print $1 }')
    task_link=$(echo $task | awk -F '|' '{ print $2 }')
    task_output=$(echo $task | awk -F '|' '{ print $3 }')

    args=()
    if [[ -f yt-dlp.conf ]]; then
      args+=("--config-locations=yt-dlp.conf")
    fi
    if [[ -n $task_output ]]; then
      args+=("--output=$task_output")
    fi
    declare -p args

    sqlite3 "$DB" "
      UPDATE dl_tasks
      SET state = $STATE_RUNNING
      WHERE id = $task_id
    "

    if yt-dlp "${args[@]}" "$task_link"; then
      sqlite3 "$DB" "
        UPDATE dl_tasks
        SET state = $STATE_DONE
        WHERE id = $task_id
      "
    fi
  done
done
