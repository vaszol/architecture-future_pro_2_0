# Задание 2: CI/CD и удалённое хранение состояния

## Описание

Автоматизация развёртывания инфраструктуры через GitLab CI/CD с удалённым хранением state в Yandex Object Storage.

## Переменные CI/CD

Настройка Secrets в GitHub Actions: Settings → Secrets and variables → Actions → New repository secret

| Secret Name   | Описание            |
|---------------|---------------------|
| YC_ACCESS_KEY | Static key ID       |
| YC_SECRET_KEY | Secret key (masked) |
| YC_CLOUD_ID   | Yandex Cloud ID     |
| YC_FOLDER_ID  | Yandex Folder ID    |

## CI/CD Pipeline

| Stage | Job   | Условие                          |
|-------|-------|----------------------------------|
| plan  | plan  | При создании Merge Request       |
| apply | apply | При merge в main (ручной запуск) |

