[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-green.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-green)](localhost.md)
[![en](https://img.shields.io/badge/lang-en-white)](../en-US/localhost.md)

## Сборка прошивки Padavan локально на Linux

### Описание

Этот скрипт позволяет вам собрать прошивку Padavan на вашей локальной машине с Linux, используя Docker или Podman для создания единообразного окружения сборки.

### Необходимые условия

* **Права суперпользователя (root):** Для запуска скрипта, так как Podman может требовать root-привилегий.
* **wget:** Для скачивания файлов.

### Использование

1. **Скачайте скрипт сборки:**

    ``` shell
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
    chmod +x build.sh
    ```

2. **(Необязательно) Настройте переменные сборки:**

    * Откройте файл `build.sh` в текстовом редакторе.
    * Измените переменные в начале скрипта, чтобы они соответствовали вашим требованиям. Доступные переменные:
       * **`PADAVAN_REPO`**: Ссылка на репозиторий Padavan (по умолчанию: `https://gitlab.com/hadzhioglu/padavan-ng.git`).
       * **`PADAVAN_BRANCH`**: Ветка репозитория (по умолчанию: `master`).
       * **`PADAVAN_COMMIT`**: Коммит для сборки (по умолчанию: `HEAD`).
       * **`PADAVAN_TOOLCHAIN_URL`**: Ссылка для скачивания toolchain (по умолчанию: `https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst`).
       * **`PADAVAN_CONFIG`**:
         * Путь к файлу конфигурации (`.config`),
          * URL-адрес файла конфигурации,
          * или оставьте пустым, чтобы использовать `build.config` (вам будет предложено выбрать шаблон).
       * **`PADAVAN_THEMES_REPO`**: Ссылка на репозиторий с темами (по умолчанию: `https://gitlab.com/hadzhioglu/padavan-themes.git`).
       * **`PADAVAN_THEMES_BRANCH`**: Ветка репозитория с темами (по умолчанию: `main`).
       * **`PADAVAN_THEMES`**: Список тем через пробел (например, `blue yellow`).
       * **`CONTAINER_IMAGE`**: Образ Docker, который будет использоваться для сборки (по умолчанию: `registry.gitlab.com/hadzhioglu/padavan-ng`).
       * **`CONTAINER_APPIMAGE_URL`**: URL-адрес Podman AppImage (по умолчанию: `https://github.com/popsUlfr/podman-appimage/releases/download/v4.2.1-r1/podman-4.2.1-r1-x86_64.AppImage`).
       * **`CLEANUP`**: Очищать ли временные файлы после сборки (по умолчанию: `true`).
       * **`RESET`**: Сбросить ли репозиторий Padavan к последнему коммиту (по умолчанию: `true`).
       * **`EDITOR`**: Команда для запуска вашего предпочитаемого текстового редактора (опционально).

3. **(Необязательно) Настройте параметры сборки:**

    * Если вы оставили переменную `PADAVAN_CONFIG` пустой, скрипт предложит вам выбрать шаблон конфигурации.
    * После выбора шаблона вам будет предложено отредактировать файл `build.config`.
    * Вы можете найти шаблон конфигурации для вашего устройства в [репозитории прошивки](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

4. **Запустите скрипт:**

    ``` shell
    sudo ./build.sh
    ```

5. **Получите прошивку:**
    * После успешной сборки скомпилированная прошивка будет находиться в той же директории, где вы запустили скрипт.

### Обновление скрипта

Так как вы используете скрипт, размещенный на Github, вы можете легко обновить его до последней версии, скачав его заново:

``` shell
wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
```

### Дополнительная информация

* Скрипт автоматически определяет, установлен ли Podman, и использует его. Если Podman недоступен, он скачивает и использует Podman AppImage.
* Лицензия прошивки Padavan не разрешает распространение готовых сборок. Скомпилированная прошивка предназначена только для личного пользования.
* Скрипт удалит временные файлы после сборки, если вы не установите переменную `CLEANUP` в `false`.
