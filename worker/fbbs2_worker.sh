#!/bin/bash
#
### BEGIN INIT INFO
# Provides: fbbs2_worker
# Required-Start: networking
# Should-Start:
# Required-Stop:
# Should-Stop:
# Default-Start: 2 3 4 5
# Default-Stop:   0 1 6
# Description: Feature Branches Build Server - Worker daemon
### END INIT INFO

INSTAL_DIR=$(dirname $(readlink -f $0))
if [ -n "$2" ]; then
    CONFIGFILE=$2
else
    CONFIGFILE=$INSTAL_DIR/config.yml.example
fi
PIDFILE=/var/run/fbbs2/worker/${CONFIGFILE##*/}_pidfile
PYTHON=python3

function _start {
    echo "Starting fbbs2 worker with config $CONFIGFILE and pidfile $PIDFILE"
    $PYTHON $INSTAL_DIR/main.py -d start -c $CONFIGFILE -p $PIDFILE
}

function _stop {
    echo "Stopping fbbs2 worker"
    $PYTHON $INSTAL_DIR/main.py -d stop -c $CONFIGFILE -p $PIDFILE
}

case "$1" in
  start)
    _start
    ;;
  stop)
    _stop
    ;;
  restart)
    echo "Restarting fbbs2 worker"
    _stop
    sleep 1
    _start
    ;;
  *)
    echo "Usage: $1 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0

