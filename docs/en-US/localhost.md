[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-green.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-white)](../ru/localhost.md)
[![en](https://img.shields.io/badge/lang-en-green)](localhost.md)

## Build Padavan Firmware Locally on Linux

### Description

This script allows you to build Padavan firmware on your local Linux machine, utilizing Docker or Podman to create a consistent build environment.

### Prerequisites

* **Root privileges:** To run the script, as Podman may require root privileges.
* **wget:** For downloading files. 

### Usage

1. **Download the build script:**

    ``` shell
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
    chmod +x build.sh
    ```

2. **(Optional) Customize build variables:**

    * Open the `build.sh` script in a text editor.
    * Modify the variables at the beginning of the script to match your requirements. The available variables are:
       * **`PADAVAN_REPO`**: Padavan repository URL (default: `https://gitlab.com/hadzhioglu/padavan-ng.git`).
       * **`PADAVAN_BRANCH`**: Repository branch (default: `master`).
       * **`PADAVAN_COMMIT`**: Commit to build (default: `HEAD`).
       * **`PADAVAN_TOOLCHAIN_URL`**: Toolchain download URL (default: `https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst`).
       * **`PADAVAN_CONFIG`**:
          * Path to your configuration file (`.config`),
          * URL of the configuration file,
          * Or leave blank to use `build.config` (you'll be prompted to select a template).
       * **`PADAVAN_THEMES_REPO`**: Themes repository URL (default: `https://gitlab.com/hadzhioglu/padavan-themes.git`).
       * **`PADAVAN_THEMES_BRANCH`**: Themes repository branch (default: `main`).
       * **`PADAVAN_THEMES`**: Space-separated list of themes (e.g., `blue yellow`).
       * **`CONTAINER_IMAGE`**: Docker image to use for building (default: `registry.gitlab.com/hadzhioglu/padavan-ng`).
       * **`CONTAINER_APPIMAGE_URL`**: URL of the Podman AppImage (default: `https://github.com/popsUlfr/podman-appimage/releases/download/v4.2.1-r1/podman-4.2.1-r1-x86_64.AppImage`).
       * **`CLEANUP`**: Whether to clean up temporary files after the build (default: `true`).
       * **`EDITOR`**: Command to launch your preferred text editor (optional).

3. **(Optional) Customize build settings:**

    * If you left the `PADAVAN_CONFIG` variable blank, the script will prompt you to select a configuration template.
    * Once the template is selected, you will have the option to edit the `build.config` file.
    * You can find a template config for your device in the [firmware repository](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

4. **Run the script:**

    ``` shell
    sudo ./build.sh
    ```

5. **Get the firmware:**
    * After a successful build, the compiled firmware will be located in the same directory where you ran the script.

### Updating the script

Since you are using a script hosted on Github, you can easily update it to the latest version by downloading it again:

``` shell
wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
```

### Additional Information

* The script automatically detects if Podman is installed and uses it. If Podman is not available, it downloads and uses the Podman AppImage.
* The Padavan firmware license does not allow distribution of pre-built binaries. Compiled firmware is for personal use only.
* The script will clean up temporary files after the build unless you set the `CLEANUP` variable to `false`.
