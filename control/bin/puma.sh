#!/usr/bin/env bash

# Simple move this file into your Rails `script` folder. Also make sure you `chmod +x puma.sh`.
# Please modify the CONSTANT variables to fit your configurations.

# The script will start with config set by $PUMA_CONFIG_FILE by default

cd $(dirname $(readlink -f $0))
cd ..

PUMA_CONFIG_FILE=config/puma.rb
PUMA_PID_FILE=tmp/pids/puma.pid
PUMA_SOCKET=tmp/sockets/puma.sock
MODE=production
SECRET_KEY_BASE_FILE=secret_key

if [ -z "$2" ]; then
    echo "Using default mode $MODE"
else
    MODE=$2
    echo "Using mode $MODE"
fi

if [ $MODE = "production" ] ; then
    if [ -e $SECRET_KEY_BASE_FILE ] ; then
        export SECRET_KEY_BASE=\"`cat $SECRET_KEY_BASE_FILE`\"
    else
        echo "No secret key file $SECRET_KEY_BASE_FILE. Please, create it and put there result of 'rake secret'"
        exit 1
    fi
fi

puma_start() {
    echo "Starting puma..."
    rm -f $PUMA_SOCKET
    if [ -e $PUMA_CONFIG_FILE ] ; then
      bundle exec puma --config $PUMA_CONFIG_FILE -e $MODE -d
    else
      bundle exec puma --bind unix://$PUMA_SOCKET --pidfile $PUMA_PID_FILE -e $MODE -t 8:1024 -d
    fi

    echo "done"
}

puma_stop() {
    echo "Stopping puma..."
    kill -s SIGTERM `cat $PUMA_PID_FILE`
    rm -f $PUMA_PID_FILE
    rm -f $PUMA_SOCKET

    echo "done"
}

case "$1" in
  start)
    puma_start
    ;;

  stop)
    puma_stop
    ;;

  restart)
    puma_stop
    sleep 3
    puma_start
    ;;

  *)
    echo "Usage: bin/puma.sh {start|stop|restart}" >&2
    ;;
esac

