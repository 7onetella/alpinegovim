#!/bin/sh

export TERM=xterm

/gotty --ws-origin ".*" -p 9000 -c ${CREDENTIAL} -w /bin/sh > /dev/stdout &

sleep 1000000000000000