# Suwayomi-Server Podman Container

This is a fork of [Suwayomi-Server-Docker](https://github.com/Suwayomi/Suwayomi-Server-docker) to better leverage a podman environment instead of docker. 

This project is not intended to replace its upstream equivalent, but merely a modification to better suit my needs, and might be useful to others.

### Podman kube play

Use the template [pod.yml](./pod.yml) in this repo for creating and starting a tachidesk pod.

# Environment Variables

> [!CAUTION]
> Providing an environment variable will <b>overwrite</b> the current setting value when starting the container.

> [!Tip]
> Most of the time you don't need to use environment variables, instead settings can be changed during runtime via the webUI. (which will be rendered useless when providing an environment variable)

> [!NOTE]
> See [server-reference.conf](https://github.com/Suwayomi/Suwayomi-Server/blob/master/server/src/main/resources/server-reference.conf) in the [Suwayomi-Server](https://github.com/Suwayomi/Suwayomi-Server) repository for the default values

There are a number of environment variables available to configure Suwayomi:

|               Variable               |     Server Default      |                                                                                              Description                                                                                              |
|:------------------------------------:|:-----------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|                **TZ**                |        `Etc/UTC`        |                                                                              What time zone the container thinks it is.                                                                               |
|             **BIND_IP**              |        `0.0.0.0`        |                                                        The interface to listen on, inside the container. You almost never want to change this.                                                        |
|            **BIND_PORT**             |         `4567`          |                                                                                  Which port Suwayomi will listen on                                                                                   |
|       **SOCKS_PROXY_ENABLED**        |         `false`         |                                                                         Whether Suwayomi will connect through a SOCKS5 proxy                                                                          |
|         **SOCKS_PROXY_HOST**         |           ` `           |                                                                                   The TCP host of the SOCKS5 proxy                                                                                    |
|         **SOCKS_PROXY_PORT**         |           ` `           |                                                                                     The port of the SOCKS5 proxy                                                                                      |
|         **DOWNLOAD_AS_CBZ**          |         `false`         |                                                                     Whether Suwayomi should save the manga to disk in CBZ format                                                                      |
|        **BASIC_AUTH_ENABLED**        |         `false`         |                                                                         Whether Suwayomi requires HTTP Basic Auth to get in.                                                                          |
|       **BASIC_AUTH_USERNAME**        |           ` `           |                                                                                  The username to log in to Suwayomi.                                                                                  |
|       **BASIC_AUTH_PASSWORD**        |           ` `           |                                                                                  The password to log in to Suwayomi.                                                                                  |
|              **DEBUG**               |         `false`         |                                                               If extra logging is enabled. Useful for development and troubleshooting.                                                                |
|          **WEB_UI_ENABLED**          |         `true`          |                                                                                  If the server should serve a webUI                                                                                   |
|          **WEB_UI_FLAVOR**           |         `WebUI`         |                                                                                          "WebUI" or "Custom"                                                                                          |
|          **WEB_UI_CHANNEL**          |        `stable`         |                                        "bundled" (the version bundled with the server release), "stable" or "preview" - the webUI version that should be used                                         |
|      **WEB_UI_UPDATE_INTERVAL**      |          `23`           |                                          Time in hours - 0 to disable auto update - range: 1 <= n < 24 - how often the server should check for webUI updates                                          |
|      **AUTO_DOWNLOAD_CHAPTERS**      |         `false`         |                                                             If new chapters that have been retrieved should get automatically downloaded                                                              |
|   **AUTO_DOWNLOAD_EXCLUDE_UNREAD**   |         `true`          |                                                                  Ignore automatic chapter downloads of entries with unread chapters                                                                   |
| **AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT** |           `0`           |                           0 to disable - how many unread downloaded chapters should be available - if the limit is reached, new chapters won't be downloaded automatically                            |
|  **AUTO_DOWNLOAD_IGNORE_REUPLOADS**  |         `false`         |                                                           Decides if re-uploads should be ignored during auto download of new chapters chapters                                                                   |
|         **EXTENSION_REPOS**          |          `[]`           |                       Any additional extension repos to use, the format is `["https://github.com/MY_ACCOUNT/MY_REPO/tree/repo", "https://github.com/MY_ACCOUNT_2/MY_REPO_2/"]`                        |
|     **MAX_SOURCES_IN_PARALLEL**      |           `6`           | Range: 1 <= n <= 20 - Sets how many sources can do requests (updates, downloads) in parallel. Updates/Downloads are grouped by source and all mangas of a source are updated/downloaded synchronously |
|      **UPDATE_EXCLUDE_UNREAD**       |         `true`          |                                                                            If unread manga should be excluded from updates                                                                            |
|      **UPDATE_EXCLUDE_STARTED**      |         `true`          |                                                                  If manga that haven't been started should be excluded from updates                                                                   |
|     **UPDATE_EXCLUDE_COMPLETED**     |         `true`          |                                                                          If completed manga should be excluded from updates                                                                           |
|         **UPDATE_INTERVAL**          |          `12`           |                 Time in hours - 0 to disable it - (doesn't have to be full hours e.g. 12.5) - range: 6 <= n < ∞ - Interval in which the global update will be automatically triggered                 |
|        **UPDATE_MANGA_INFO**         |         `false`         |                                                                        If manga info should be updated along with the chapters                                                                        |
|           **BACKUP_TIME**            |         `00:00`         |                                                    Range: hour: 0-23, minute: 0-59 - Time of day at which the automated backup should be triggered                                                    |
|         **BACKUP_INTERVAL**          |           `1`           |                                         Time in days - 0 to disable it - range: 1 <= n < ∞ - Interval in which the server will automatically create a backup                                          |
|            **BACKUP_TTL**            |          `14`           |                                         Time in days - 0 to disable it - range: 1 <= n < ∞ - How long backup files will be kept before they will get deleted                                          |
|       **FLARESOLVERR_ENABLED**       |         `false`         |                                                                         Whether FlareSolverr is enabled and available to use                                                                          |
|         **FLARESOLVERR_URL**         | `http://localhost:8191` |                                                                                 The URL of the FlareSolverr instance                                                                                  |
|       **FLARESOLVERR_TIMEOUT**       |          `60`           |                                                              Time in seconds for FlareSolverr to timeout if the challenge is not solved                                                               |
|    **FLARESOLVERR_SESSION_NAME**     |       `suwayomi`        |                                                                   The name of the session that Suwayomi will use with FlareSolverr                                                                    |
|     **FLARESOLVERR_SESSION_TTL**     |          `15`           |                                                                             The time to live for the FlareSolverr session                                                                             |

# Docker tags

## Latest

`ghcr.io/suwayomi/suwayomi-server:latest` 

The latest stable release of the server. Also tagged as `:stable`.

# Credit

[Suwayomi-Server](https://github.com/Suwayomi/Suwayomi-Server) is licensed under `MPL v. 2.0`.

[Suwayomi-Server-Docker](https://github.com/Suwayomi/Suwayomi-Server-docker) is licensed under `MPL v. 2.0`.

# License

    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
