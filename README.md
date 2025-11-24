# Suwayomi-Server Pod

This is a fork of [Suwayomi-Server-Docker](https://github.com/Suwayomi/Suwayomi-Server-docker) to better leverage a podman environment instead of docker. This container is suited for a rootless environemnt, but you can force non-root execution through the `runAs` options:

```yaml
securityContext:
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  runAsUser: 1000 # Replaces usual PUID configurations
  runAsGroup: 1000 # Replaces usual PGID configurations  
```

This project is not intended to replace its upstream equivalent, but merely a modification to better suit my needs, and might be useful to others.

## Podman kube play

Use the template [suwayomi.pod.yaml](./suwayomi.pod.yml) in this repo for creating and starting a suwayomi server pod with [podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube.1.html), you just need to define your bind path for the `suwayomi-directory` volume (or exclude/comment the entry if you don't want any persistance):

```yaml
  - name: suwayomi-directory
    hostPath:
      path: /your/host/path # your host directory path
      type: DirectoryOrCreate
```

_**Suwayomi data location - /suwayomi**_

This image is based on [Red Hat's Minimal Universal Base Image 10](https://hub.docker.com/r/redhat/ubi10-minimal)

## Environment Variables

Currently the only environment variable used by this setup is:

|Variable|Server Default|Description|
|:-:|:-:|:-:|
|**TZ**|`Etc/UTC`|What time zone the container thinks it is.|

Instead of using environment variables, this setup leverages the support that podman has for k8s ConfigMaps, and have our server.conf be a mounted config map so that the server settings are static and defined by the yaml file.

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: suwayomi-config
data:
  server.conf: |- #properties
    # Server ip and port bindings
    server.ip = "0.0.0.0"
    server.port = 4567

    # Socks5 proxy
    server.socksProxyEnabled = false
    server.socksProxyVersion = 5 # 4 or 5
    server.socksProxyHost = ""
    server.socksProxyPort = ""
    server.socksProxyUsername = ""
    server.socksProxyPassword = ""

    # webUI
    server.webUIEnabled = true
    server.initialOpenInBrowserEnabled = false
    server.webUIInterface = "browser" # "browser" or "electron"
    ...etc
```

> [!NOTE]
> See the [Suwayomi wiki page on configuration](https://github.com/Suwayomi/Suwayomi-Server/wiki/Configuring-Suwayomi%E2%80%90Server) in the [Suwayomi-Server](https://github.com/Suwayomi/Suwayomi-Server) repository for the default values and explanation

## Downloads Folder

If you want to use different download folder, you can set that through either `volumeMounts` or the server.conf configMap. Remember that if you change the `server.downloadsPath` value and want the downloads to be persisted, you need to map the same directory on your volumeMounts definitions.

```yaml
    ...
    volumeMounts:
      - mountPath: /my/download/path
        name: suwayomi-downloads
      # - mountPath: /suwayomi/backups
      #   name: suwayomi-backups
      # - mountPath: /suwayomi/logs
      #   name: suwayomi-logs
      - mountPath: /suwayomi
        name: suwayomi-directory
      - mountPath: /suwayomi/server.conf
        name: suwayomi-config-file
        subPath: server.conf
    ...

    ...
    # downloader
    server.downloadAsCbz = true
    server.downloadsPath = "/my/download/path"
    server.autoDownloadNewChapters = true
    server.excludeEntryWithUnreadChapters = true
    ...
```

## Credit

[Suwayomi-Server](https://github.com/Suwayomi/Suwayomi-Server) is licensed under `MPL v. 2.0`.

[Suwayomi-Server-Docker](https://github.com/Suwayomi/Suwayomi-Server-docker) is licensed under `MPL v. 2.0`.

## License

```text
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
```
