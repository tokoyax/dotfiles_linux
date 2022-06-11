#!/bin/sh

# start lemonade
c=$(ps aux | grep lemonade | grep -v grep | wc -l)
if [ $c -ne 1 ]; then
    $HOME/go/bin/lemonade server --log-level=4 &
    echo 'lemonade server invoked.'
fi

# start ssh-agent
eval `ssh-agent` > /dev/null 2>&1
eval `ssh-add ~/.ssh/carbuncle-key > /dev/null 2>&1`

