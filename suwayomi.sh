#!/bin/bash
export TZ="${TZ:-Etc/UTC}"
supercronic /etc/cron.d/suwayomi &
java -Dsuwayomi.tachidesk.config.server.rootDir="/suwayomi" --enable-native-access=ALL-UNNAMED -jar /usr/local/bin/suwayomi.jar
