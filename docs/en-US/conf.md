[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-red.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-white)](../ru/conf.md)
[![en](https://img.shields.io/badge/lang-en-green)](conf.md)

## build.conf Parameters

| Parameter | Description | Default |
|---|---|---|
| `PADAVAN_REPO` | Padavan repository URL. | `https://gitlab.com/hadzhioglu/padavan-ng.git` |
| `PADAVAN_BRANCH` | Padavan repository branch. | `master` |
| `PADAVAN_COMMIT` | Commit to build. | `HEAD` |
| `PADAVAN_TOOLCHAIN_URL` | Toolchain archive URL. | `https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst` |
| `PADAVAN_CONFIG` |  | `build.config` |
| | * Path to the configuration file (`.config`) in your repository, | |
| | * or URL of the configuration file, | |
| | * or leave blank to use [`build.config`](../../build.config). | |
| `PADAVAN_THEMES_REPO` | Themes repository URL. | `https://gitlab.com/hadzhioglu/padavan-themes.git` |
| `PADAVAN_THEMES_BRANCH` | Themes repository branch. | `main` |
| `PADAVAN_THEMES` | Space-separated list of themes (e.g., `blue yellow`). |  |
| `CONTAINER_IMAGE` | Docker image used for building. | `registry.gitlab.com/hadzhioglu/padavan-ng` |
| `CONTAINER_APPIMAGE_URL` | URL of the Podman AppImage. | `https://github.com/popsUlfr/podman-appimage/releases/download/v4.2.1-r1/podman-4.2.1-r1-x86_64.AppImage` |
| `BUILDER_DEPENDENCIES` | Whether to install dependencies for local builds. | `true` |
| `BUILDER_CLEANUP` | Whether to clean up temporary files after the build. | `true` |
| `BUILDER_RESET` | Whether to reset the Padavan repository to the latest commit before building. | `true` |
| `BUILDER_EDITOR` | Command to launch your preferred text editor. |  |
| `BUILDER_OUTPUT` | Directory to store the built firmware. | (current directory) |
| `BUILDER_TEMP` | Directory to store temporary files. | (current directory) |
| `BUILDER_CONFIG` | Path to the build configuration file. | build.conf |
