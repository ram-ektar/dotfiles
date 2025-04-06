#!/bin/bash

etc=/Applications/Docker.app/Contents/Resources/etc
completion_dir=$(brew --prefix)/etc/bash_completion.d

# Create symbolic links only if destinations don't exist
if [ ! -f "$completion_dir/docker" ]; then
    ln -s $etc/docker.bash-completion $completion_dir/docker
fi

if [ ! -f "$completion_dir/docker-machine" ]; then
    ln -s $etc/docker-machine.bash-completion $completion_dir/docker-machine
fi

if [ ! -f "$completion_dir/docker-compose" ]; then
    ln -s $etc/docker-compose.bash-completion $completion_dir/docker-compose
fi
