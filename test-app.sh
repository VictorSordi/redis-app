#!/bin/bash
RESULT="`wget -qO- http://localhost:8090`"
wget -q localhost:8090
if [ $? -eq 0 ]
then
    echo 'Ok - service ON'
elif [ "$RESULT" = *"Number"* ]
then
    echo 'OK - number of visits'
    echo "$RESULT"
else
    echo 'OFF - number of visits'
    exit 1
fi