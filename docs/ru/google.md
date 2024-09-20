[![github](https://img.shields.io/badge/GITHUB-builder-red.svg)](github.md)
[![google](https://img.shields.io/badge/GOOGLE-builder-green.svg)](google.md)
[![localhost](https://img.shields.io/badge/LOCALHOST-builder-red.svg)](localhost.md)
[![ru](https://img.shields.io/badge/lang-ru-green)](google.md)
[![en](https://img.shields.io/badge/lang-en-white)](../en-US/google.md)

## Сборка прошивки Padavan с помощью Google Colab

### Использование

1. **Откройте блокнот в Google Colab:**

    [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/alex2844/padavan-builder/blob/main/build.ipynb)

2. **Авторизуйтесь** в Google Colab.

3. **Задайте переменные в разделе "Settings":**
    * Описание переменных представлено в таблице [build.conf](conf.md).
    * **CONFIG:**
        * Укажите **путь к файлу конфигурации (`.config`)** на вашем Google Drive, URL-адрес файла,
        * **или используйте путь из репозитория Padavan** (например, `padavan-ng/trunk/configs/templates/xiaomi/mi-4a_100m.config`),
        * **или оставьте пустым**, чтобы использовать `build.config`.
    * **ZIP:**
        * `download`: Скачать архив с прошивкой после сборки.
        * `save`: Сохранить архив с прошивкой на Google Drive.

    ![variables](../images/google_variables.png)

4. **(Необязательно) Настройка параметров сборки:**
    * Если в переменной `CONFIG` вы оставили значение по умолчанию (`build.config`), отредактируйте этот файл в соответствии с вашими требованиями.
    * Шаблон конфига для вашего устройства можно взять в [репозитории прошивки](https://gitlab.com/hadzhioglu/padavan-ng/-/tree/master/trunk/configs/templates)

    ![config](../images/google_config.png)

5. **Запустите все ячейки кода:** Нажмите `Runtime` -> `Run all`.

    ![runtime](../images/google_runtime.png)

6. **Дождитесь окончания сборки:** Процесс сборки займет некоторое время (30-60 минут). Вы можете наблюдать за прогрессом в выводе ячеек кода.

7. **Скачайте прошивку:**
    * Если вы выбрали `ZIP = 'download'`, архив с прошивкой будет загружен автоматически.
    * Если вы выбрали `ZIP = 'save'`, архив с прошивкой будет сохранен в папку `MyDrive` на вашем Google Drive.
