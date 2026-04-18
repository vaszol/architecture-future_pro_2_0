---
title: "Apache Camel"
ring: hold
quadrant: tools
tags: [legacy, integration, to-be-migrated]
---

# Apache Camel

Apache Camel — старая ESB, заменяем на Kafka.

## Обоснование

- Единая точка отказа
- Синхронная связанность
- Сложность масштабирования
- Замена на EDA с Kafka

## План миграции

- ACL слой для интеграции
- Поэтапный перевод на события