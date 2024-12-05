#!/bin/bash
RESULT="`wget http://localhost:8070`"
echo "RESULT: $RESULT"  # Debugging line to print the result
wget -q localhost:8070
if [ $? -eq 0 ]
then
    echo 'Ok - service ON'
elif [[ "$RESULT" == *"Number"* ]]
then
    echo 'OK - number of visits'
    echo "$RESULT"
else
    echo 'OFF - number of visits'
    echo "DEBUG: $RESULT"  # Debugging line
    exit 1
fi