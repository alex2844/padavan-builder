[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-green.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-red.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-white)](../ru/google.md)
[![en](https://img.shields.io/badge/lang-en-green)](google.md)

## Build Padavan firmware with Google Colab

### Usage

1. **Open the notebook in Google Colab:**

    [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/alex2844/padavan-builder/blob/main/build.ipynb)

2. **Authorize** in Google Colab.

3. **Set the variables in the "Settings" section:**
    * For a description of the variables, see the table [build.conf](conf.md).
    * **CONFIG:**
        * Specify the **path to the configuration file (`.config`)** on your Google Drive, URL of the file,
        * **or use the path from the Padavan repository** (e.g. `padavan-ng/trunk/configs/templates/xiaomi/mi-4a_100m.config`),
        * **or leave it blank** to use `build.config`.
    * **ZIP:**
        * `download`: Download the firmware archive after building.
        * `save`: Save the firmware archive to Google Drive.

    ![variables](../images/google_variables.png)

4. **(Optional) Customize build settings:**
    * If you left the default value (`build.config`) in the `CONFIG` variable, edit this file according to your requirements.
    * You can find the template config for your device in the [firmware repository](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

    ![config](../images/google_config.png)

5. **Run all code cells:** Click `Runtime` -> `Run all`.

    ![runtime](../images/google_runtime.png)

6. **Wait for the build to complete:** The build process will take some time (30-60 minutes). You can monitor the progress in the output of the code cells.

7. **Download the firmware:**
    * If you chose `ZIP = 'download'`, the firmware archive will be downloaded automatically.
    * If you chose `ZIP = 'save'`, the firmware archive will be saved to the `MyDrive` folder on your Google Drive.
