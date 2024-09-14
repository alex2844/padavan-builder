[![github](https://img.shields.io/badge/GITHUB-builder-green.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-red.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-white)](../ru/github.md)
[![en](https://img.shields.io/badge/lang-en-green)](github.md)

## Build Padavan firmware with Github Actions

### Usage

1. **Create a copy (fork) of this repository:**

    [![fork](https://img.shields.io/static/v1?message=Create+fork&logo=github&labelColor=5c5c5c&color=1182c3&logoColor=white&label=%20)](https://github.com/alex2844/padavan-builder/fork)

2. **(Optional) Configure build variables:**
   * In your fork, open the [`variables`](../../variables) file at the root of the repository.
   * Modify the variables according to your requirements:
     * **`PADAVAN_REPO`:** Link to the Padavan repository (default: `https://gitlab.com/hadzhioglu/padavan-ng.git`).
     * **`PADAVAN_BRANCH`:** Repository branch (default: `master`).
     * **`PADAVAN_COMMIT`:** Commit to build (default: `HEAD`).
     * **`PADAVAN_TOOLCHAIN_URL`:** Link to the toolchain file (default: `https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst`).
     * **`PADAVAN_CONFIG`**:
         * **Path to the configuration file (`.config`)** in your repository,
         * **or URL of the configuration file**,
         * **or leave blank** to use `build.config`.
     * **`PADAVAN_THEMES_REPO`**: Link to the themes repository (default: `https://gitlab.com/hadzhioglu/padavan-themes.git`).
     * **`PADAVAN_THEMES_BRANCH`**: Branch of the themes repository (default: `main`).
     * **`PADAVAN_THEMES`**: Space-separated list of themes (e.g., `blue yellow`).

3. **(Optional) Configure build settings:**
   * Open the [`build.config`](../../build.config) file at the root of the repository and edit it according to your requirements.
   * This step is optional if you have specified a path to a different configuration file in the `PADAVAN_CONFIG` variable.
   * You can find a template config for your device in the [firmware repository](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

4. **(Optional) Add your custom scripts:**
   * Create a file `pre-build.sh` at the root of the repository to execute commands before building the firmware.
   * Create a file `post-build.sh` at the root of the repository to execute commands after building the firmware.

5. **Start the build:**
   * Navigate to the **Actions** section of your fork on Github.
   * Select the workflow **`Build firmware`**.
   * Click **"Run workflow"**, select a branch, and confirm the launch by clicking the **"Run workflow"** button:

     ![build](../images/github_build.png)

6. **Download the firmware:**
   * After the build is successful (usually takes 15 minutes to an hour), go to the **"Summary"** tab on the workflow run page.
   * In the **Artifacts** section, click the download button next to the name of your archive:

     ![zip](../images/github_zip.png)

### Updating the fork

Periodically, updates may be made to this repository. To get these updates in your fork, follow these steps:

1. Open the page of your fork on Github.
2. You will see a notification that your fork is behind the original repository **if updates are available**.
3. Click the **"Sync fork"** button, and then **"Update branch"**:

    ![update](../images/github_update.png)

4. Wait for the synchronization to complete.

**If your fork is already up-to-date, you will see the following notification:**

![not update](../images/github_not_update.png)

### Additional information

* The Padavan firmware license does not allow distribution of pre-built binaries. Compiled firmware is for personal use only. The archive with your firmware will be stored in Github Actions for 7 days.
