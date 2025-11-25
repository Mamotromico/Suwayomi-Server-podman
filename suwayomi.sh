#!/bin/bash
export TZ="${TZ:-Etc/UTC}"
java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Dsuwayomi.tachidesk.config.server.rootDir="/suwayomi" --enable-native-access=ALL-UNNAMED -jar /usr/local/bin/suwayomi.jar
