---
title: "Microsoft SQL Server 2008"
ring: hold
quadrant: platforms-and-operations
tags: [legacy, database, to-be-migrated]
---

# Microsoft SQL Server 2008

SQL Server 2008 — легаси DWH, выводим из эксплуатации.

## Обоснование

- Устаревшая версия без поддержки
- Высокая стоимость лицензий
- Batch-обработка (часы)
- Замена на ClickHouse + Kafka

## План миграции

- Этап 1: Dual-write
- Этап 2: Миграция отчётов
- Этап 3: Отключение