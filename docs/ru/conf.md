[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-red.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-green)](conf.md)
[![en](https://img.shields.io/badge/lang-en-white)](../en-US/conf.md)

## Параметры build.conf

| Параметр | Описание | По умолчанию |
|---|---|---|
| `PADAVAN_REPO` | URL-адрес репозитория Padavan. | `https://gitlab.com/hadzhioglu/padavan-ng.git` |
| `PADAVAN_BRANCH` | Ветка репозитория Padavan. | `master` |
| `PADAVAN_COMMIT` | Коммит для сборки. | `HEAD` |
| `PADAVAN_TOOLCHAIN_URL` | URL-адрес архива toolchain. | `https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst` |
| `PADAVAN_CONFIG` |  | `build.config` |
| | * Путь к файлу конфигурации (`.config`) в вашем репозитории,  | |
| | * или URL-адрес файла конфигурации, | |
| | * или оставьте пустым, чтобы использовать [`build.config`](../../build.config). | |
| `PADAVAN_THEMES_REPO` | URL-адрес репозитория с темами. | `https://gitlab.com/hadzhioglu/padavan-themes.git` |
| `PADAVAN_THEMES_BRANCH` | Ветка репозитория с темами. | `main` |
| `PADAVAN_THEMES` | Список тем через пробел. (например, `blue yellow`). |  |
| `CONTAINER_IMAGE` | Docker-образ, используемый для сборки. | `registry.gitlab.com/hadzhioglu/padavan-ng` |
| `CONTAINER_APPIMAGE_URL` | URL-адрес Podman AppImage. | `https://github.com/popsUlfr/podman-appimage/releases/download/v4.2.1-r1/podman-4.2.1-r1-x86_64.AppImage` |
| `BUILDER_DEPENDENCIES` | Устанавливать ли зависимости для локальной сборки. | `true` |
| `BUILDER_CLEANUP` | Очищать ли временные файлы после сборки. | `true` |
| `BUILDER_RESET` | Сбрасывать ли репозиторий Padavan к последнему коммиту перед сборкой. | `true` |
| `BUILDER_EDITOR` | Команда для запуска предпочитаемого текстового редактора. |  |
