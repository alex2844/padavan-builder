# Padavan Builder

## Build Padavan firmware - easy!

This project provides simple and convenient ways to build Padavan firmware for your router. You can choose the method that suits you best:

* **Github Actions:** Automated build on Github servers. 
* **Google Colab:** Build in the Google Colab cloud environment.
* **Local build:** Build on your Linux machine using Docker or Podman.

## File Description

* **[`build.sh`](../build.sh):** Main script for building the firmware.
* **[`build.conf`](../build.conf):** Build configuration file containing variables that define Padavan repository parameters, toolchain, Docker image, and other settings. For a description of the variables, see the table [build.conf](en-US/conf.md).
* **[`build.config`](../build.config):** Padavan configuration file defining the firmware settings.

## Getting Started

1. **Choose your preferred build method.**
2. **Follow the corresponding link below.**
3. **Follow the detailed instructions.**

## Available Build Methods:

* [Build with Github Actions](en-US/github.md)
* [Build with Google Colab](en-US/google.md)
* [Build on your local machine](en-US/localhost.md)


## Сборка прошивки Padavan - просто!

Этот проект предлагает простые и удобные способы сборки прошивки Padavan для вашего роутера. Вы можете выбрать подходящий для вас метод:

* **Github Actions:** Автоматическая сборка на серверах Github.
* **Google Colab:** Сборка в облачной среде Google Colab. 
* **Локальная сборка:** Сборка на вашей Linux машине с помощью Docker или Podman.

## Описание файлов

* **[`build.sh`](../build.sh):** Главный скрипт для сборки прошивки.
* **[`build.conf`](../build.conf):** Файл конфигурации сборки. Содержит переменные, определяющие параметры репозитория Padavan, toolchain, Docker-образа и другие настройки. Описание переменных представлено в таблице [build.conf](ru/conf.md).
* **[`build.config`](../build.config):** Файл конфигурации Padavan, определяющий настройки прошивки.

## Как начать?

1. **Выберите предпочитаемый метод сборки.**
2. **Перейдите по соответствующей ссылке ниже.**
3. **Следуйте подробной инструкции.**

## Доступные методы сборки:

* [Сборка с помощью Github Actions](ru/github.md)
* [Сборка с помощью Google Colab](ru/google.md)
* [Сборка на локальной машине](ru/localhost.md)

## Youtube
| [![github][github_img]][github_url] | [![google][google_img]][google_url] | [![linux][linux_img]][linux_url] | [![windows][windows_img]][windows_url]
| --- | --- | --- | ---

[github_img]: https://img.youtube.com/vi/6Qlkx5JcQdg/0.jpg "Github Actions"
[github_url]: https://youtu.be/6Qlkx5JcQdg
[google_img]: https://img.youtube.com/vi/hSdi5K50KlY/0.jpg "Google Colab"
[google_url]: https://youtu.be/hSdi5K50KlY
[linux_img]: https://img.youtube.com/vi/vdFtsq32Pxg/0.jpg "Local build: Linux"
[linux_url]: https://youtu.be/vdFtsq32Pxg
[windows_img]: https://img.youtube.com/vi/NDYlXdCvy2I/0.jpg "Local build: Windows"
[windows_url]: https://youtu.be/NDYlXdCvy2I
