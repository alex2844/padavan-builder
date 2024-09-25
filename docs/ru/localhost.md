[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-red.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-green.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-green)](localhost.md)
[![en](https://img.shields.io/badge/lang-en-white)](../en-US/localhost.md)

## Сборка прошивки Padavan локально

### Описание

Этот скрипт позволяет вам собрать прошивку Padavan на вашей локальной машине, используя Docker или Podman для создания единообразного окружения сборки.

### Необходимые условия

* **Права суперпользователя (root):** Для запуска скрипта, так как Podman может требовать root-привилегий.
* **wget:** Для скачивания файлов.

### Использование

1. **Скачайте [скрипт сборки](../../../../raw/main/build.sh) и [файл конфигурации](../../../../raw/main/build.conf):**
    ```shell
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
    wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.conf
    chmod +x build.sh
    ```

2. **(Необязательно) Настройте переменные сборки:**
    * Откройте файл `build.conf` в текстовом редакторе.
    * Измените переменные в соответствии с вашими требованиями.
    * Описание переменных представлено в таблице [build.conf](conf.md).

3. **(Необязательно) Настройте параметры сборки:**
    * Если вы оставили переменную `PADAVAN_CONFIG` пустой, скрипт предложит вам выбрать шаблон конфигурации.
    * После выбора шаблона вам будет предложено отредактировать файл `build.config`.
    * Вы можете найти шаблон конфигурации для вашего устройства в [репозитории прошивки](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates).

4. **(Необязательно) Добавьте свои скрипты:**
    * Создайте файл `pre_build.sh` для выполнения команд перед сборкой прошивки.
    * Создайте файл `post_build.sh` для выполнения команд после сборки прошивки.

5. **Запустите скрипт:**

    **Linux/WSL:**
    ```shell
    sudo ./build.sh
    ```
    **Docker:**
    ```powershell
    docker run -it --rm -v "${PWD}:/opt" -w /opt -e BUILDER_TEMP=/tmp registry.gitlab.com/hadzhioglu/padavan-ng ./build.sh
    ```

6. **Получите прошивку:**
    * После успешной сборки скомпилированная прошивка будет находиться в той же директории, где вы запустили скрипт.

### Обновление скрипта

Так как вы используете скрипт, размещенный на Github, вы можете легко обновить его до последней версии, скачав его заново:

```shell
wget https://raw.githubusercontent.com/alex2844/padavan-builder/main/build.sh
```

### Дополнительная информация

* Скрипт автоматически определяет, установлен ли Podman, и использует его. Если Podman недоступен, он скачивает и использует Podman AppImage.
* Лицензия прошивки Padavan не разрешает распространение готовых сборок. Скомпилированная прошивка предназначена только для личного пользования.
* Скрипт удалит временные файлы после сборки, если вы не установите переменную `BUILDER_CLEANUP` в `false`.
