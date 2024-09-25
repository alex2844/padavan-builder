[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-green.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-white)](../ru/localhost.md)
[![en](https://img.shields.io/badge/lang-en-green)](localhost.md)

## Build Padavan Firmware Locally

### Description

This script allows you to build Padavan firmware on your local machine using Docker or Podman to create a consistent build environment.

### Prerequisites

* **Root privileges:** To run the script, as Podman may require root privileges.
* **wget:** For downloading files. 

### Usage

1. **Download the [build script](../../../../raw/main/build.sh) and [configuration file](../../../../raw/main/build.conf):**
    ```shell
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.conf
    chmod +x build.sh
    ```

2. **(Optional) Customize build variables:**
    * Open the `build.conf` script in a text editor.
    * Modify the variables according to your requirements.
    * For a description of the variables, see the table [build.conf](conf.md).

3. **(Optional) Customize build settings:**
    * If you left the `PADAVAN_CONFIG` variable blank, the script will prompt you to select a configuration template.
    * Once the template is selected, you will have the option to edit the `build.config` file.
    * You can find a template config for your device in the [firmware repository](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

4. **(Optional) Add your custom scripts:**
    * Create a file `pre_build.sh` to execute commands before building the firmware.
    * Create a file `post_build.sh` to execute commands after building the firmware.

5. **Run the script:**

    **Linux/WSL:**
    ```shell
    sudo ./build.sh
    ```
    **Docker:**
    ```powershell
    docker run -it --rm -v "${PWD}:/opt" -w /opt -e BUILDER_TEMP=/tmp registry.gitlab.com/hadzhioglu/padavan-ng ./build.sh
    ```

6. **Get the firmware:**
    * After a successful build, the compiled firmware will be located in the same directory where you ran the script.

### Updating the script

Since you are using a script hosted on Github, you can easily update it to the latest version by downloading it again:

```shell
wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
```

### Additional Information

* The script automatically detects if Podman is installed and uses it. If Podman is not available, it downloads and uses the Podman AppImage.
* The Padavan firmware license does not allow distribution of pre-built binaries. Compiled firmware is for personal use only.
* The script will clean up temporary files after the build unless you set the `BUILDER_CLEANUP` variable to `false`.
