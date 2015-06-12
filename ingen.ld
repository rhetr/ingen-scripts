# vim:filetype=sh
#!/bin/bash
# ingen.load-default

trap 'kill -TERM $PID' TERM INT 
ingen -e &
PID=$!
sleep 1
ingen.mdo

wait $PID
trap - TERM INT 
wait $PID
EXIT_STATUS=$?

