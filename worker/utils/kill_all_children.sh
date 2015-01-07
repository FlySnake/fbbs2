#!/bin/sh

list_descendants ()
{
    local children=$(ps -o pid= --ppid "$1")
    for pid in $children
    do
        list_descendants "$pid"
    done
    echo "$children"
}

PIDS=$(list_descendants $1)
echo $PIDS
exit $(kill $PIDS)