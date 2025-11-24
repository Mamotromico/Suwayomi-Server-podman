#!/bin/bash
export TZ="${TZ:-Etc/UTC}"
java -Dsuwayomi.tachidesk.config.server.rootDir="/suwayomi" --enable-native-access=ALL-UNNAMED -jar /usr/local/bin/suwayomi.jar
