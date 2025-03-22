#!/bin/bash

# exit early in case the file already exists
if [ -f ~/.local/share/Tachidesk/server.conf ]; then
    exit 0
fi

mkdir -p ~/.local/share/Tachidesk

# extract the server reference config from the jar
unzip -q -j ~/startup/tachidesk_latest.jar "server-reference.conf" -d ~/startup

# move and rename the reference config
mv ~/startup/server-reference.conf ~/.local/share/Tachidesk/server.conf
