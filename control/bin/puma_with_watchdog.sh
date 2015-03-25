#!/usr/bin/env bash

cd $(dirname $(readlink -f $0))
cd ..

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

export RAILS_ENV=$MODE

puma_start() 
{
    echo "Starting puma with watchdog"
    bundle exec god -c config/puma_watchdog.god
    sleep 2
    bundle exec god start fbbs2_puma 
}

puma_stop() 
{
    echo "Stopping puma with watchdog"
    bundle exec god signal fbbs2_puma 9 && bundle exec god terminate
    #bundle exec god stop fbbs2_puma
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
    echo "Usage: $0 {start|stop|restart}" >&2
    ;;
esac

