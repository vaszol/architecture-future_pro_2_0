# Детали миграции ESB и бизнес-логики

## 1. Миграция компонентов ESB (Apache Camel)

| Компонент ESB                  | Куда мигрирует                       | Обоснование                                 |
|--------------------------------|--------------------------------------|---------------------------------------------|
| Маршрутизация сообщений        | Kafka + Kafka Streams                | Событийная шина с persistent storage        |
| Трансформации (data mapping)   | Kafka Streams / Flink                | Stream processing с exactly-once семантикой |
| Enrichment (обогащение данных) | Kafka Streams + Materialized Views   | Интерактивные запросы в ClickHouse          |
| Content-based routing          | Kafka + Consumer Groups              | Разные топики + партиционирование           |
| Message filtering              | Kafka Streams / Flink                | Фильтрация на этапе stream processing       |
| Protocol bridging              | API Gateway (Kong) + Kafka           | Входные адаптеры через API Gateway          |
| Агрегация сообщений            | Kafka Streams (windowed aggregation) | Flink для сложных оконных операций          |
| Splitting / routing            | Kafka Streams (branching)            | Разделение потоков                          |
| Error handling / DLQ           | Kafka Dead Letter Queue + Мониторинг | Встроенный DLQ + алертинг                   |
| Idempotent consumer            | Kafka Transactions                   | Гарантии доставки                           |

## 2. Миграция бизнес-логики из DWH

| Бизнес-логика (DWH)   | Куда мигрирует                  | Пример                      |
|-----------------------|---------------------------------|-----------------------------|
| Хранимые процедуры    | Микросервисы (Go/Java)          | Расчёт кредитного скоринга  |
| ETL трансформации     | dbt + ClickHouse                | Очистка и аггрегация данных |
| Business rules        | Domain services + Kafka Streams | Правила валидации диагнозов |
| Агрегации для отчётов | Materialized Views в ClickHouse | Отчёты по продажам          |
| Data quality checks   | Great Expectations + dbt tests  | Проверка консистентности    |
| Batch-джобы           | Airflow + Kubernetes Jobs       | Ночные отчёты               |

## 3. Куда разъезжается ESB (детально)

### Функционально-логические компоненты

| ESB компонент | Назначение                              | Целевое решение                                  |
|---------------|-----------------------------------------|--------------------------------------------------|
| Маршрутизация | Определение куда отправить сообщение    | Kafka Consumer Groups + Routing logic в сервисах |
| Трансформация | Изменение формата сообщения             | Kafka Streams / Flink                            |
| Обогащение    | Добавление данных из внешних источников | Kafka Streams + Lookup (KV Store/Redis)          |
| Фильтрация    | Отсев нерелевантных сообщений           | Kafka Streams .filter()                          |
| Агрегация     | Сборка сообщений во времени             | Kafka Streams windowed aggregation               |
| Сплиттинг     | Разбивка сообщения на части             | Kafka Streams .flatMap()                         |

### Инфраструктурные компоненты

| ESB компонент     | Назначение           | Целевое решение                       |
|-------------------|----------------------|---------------------------------------|
| Message Broker    | Хранение и доставка  | Apache Kafka (managed)                |
| Dead Letter Queue | Обработка ошибок     | Kafka DLQ + Алертинг                  |
| Message Store     | Персистентность      | Kafka topics (retention 7-30 дней)    |
| Monitoring        | Наблюдаемость        | Prometheus + Grafana + Kafka Exporter |
| Tracing           | Трассировка запросов | Jaeger + OpenTelemetry                |

## 4. Архитектурная схема миграции

### Текущее состояние (ESB + DWH)

Текстовая схема:

    Service A ---> ESB (Camel) ---> DWH (SQL)
                         |
    Service B ---> Routing ---> Отчёты (batch)

### Промежуточное состояние (ACL + Dual-write)

Текстовая схема:

    Service A ---> ACL (адаптер) ---> Kafka Event Bus
                       |                   |
                       |                   +---> Новый сервис C
                       |
                       +---> DWH (легаси) [dual-write]

### Целевое состояние (Event-Driven + Streams)

Текстовая схема:

    Service A ---> Kafka Topic ---> Kafka Streams ---> ClickHouse (analytics)
                                       |
    Service B ---> Kafka Topic ---> Flink ---> Materialized View / Dashboard

    Service C ---> Kafka Topic ---> API Gateway (external)

## 5. Поэтапный план миграции ESB

### Этап 1 (0-6 месяцев): Подготовка

| Действие                   | Ответственный    | Результат               |
|----------------------------|------------------|-------------------------|
| Развернуть Kafka кластер   | Platform Team    | Kafka ready             |
| Создать ACL слой для ESB   | Integration Team | Dual-write возможность  |
| Настроить мониторинг       | SRE              | Prometheus + Grafana    |
| Определить пилотные потоки | Architects       | 2-3 потока для миграции |

### Этап 2 (6-18 месяцев): Постепенная миграция

| Действие                    | Ответственный    | Результат               |
|-----------------------------|------------------|-------------------------|
| Мигрировать маршрутизацию   | Stream Engineers | Routing в Kafka Streams |
| Мигрировать трансформации   | Data Engineers   | Transforms в Flink      |
| Мигрировать обогащение      | Domain Teams     | Enrichment в сервисах   |
| Переключить пилотные потоки | Integration Team | 3 потока на Kafka       |

### Этап 3 (18-36 месяцев): Завершение

| Действие                      | Ответственный    | Результат             |
|-------------------------------|------------------|-----------------------|
| Отключить старые маршруты     | Integration Team | ESB в read-only       |
| Мигрировать оставшиеся потоки | Domain Teams     | 100% потоков на Kafka |
| Выключить ESB                 | Platform Team    | ESB decommissioned    |
| Документирование              | Architects       | Итоговый отчёт        |

## 6. Сроки миграции компонентов

| Компонент            | Старт    | Завершение | Ответственный      |
|----------------------|----------|------------|--------------------|
| Маршрутизация        | Месяц 6  | Месяц 18   | Platform Team      |
| Трансформации        | Месяц 6  | Месяц 18   | Data Engineers     |
| Бизнес-логика из DWH | Месяц 0  | Месяц 18   | Domain Teams       |
| DLQ и мониторинг     | Месяц 0  | Месяц 6    | SRE                |
| API Gateway          | Месяц 3  | Месяц 12   | Platform Team      |
| Полный отказ ESB     | Месяц 24 | Месяц 36   | Architecture Board |

## 7. Риски миграции ESB

| Риск                              | Вероятность | Меры по снижению                        |
|-----------------------------------|-------------|-----------------------------------------|
| Потеря сообщений при переключении | Средняя     | Dual-write, exactly-once семантика      |
| Несовместимость форматов          | Средняя     | Schema Registry, versioning             |
| Увеличение задержек               | Низкая      | Performance testing, auto-scaling       |
| Сложность отладки                 | Высокая     | Distributed tracing, structured logging |
| Отсутствие компетенций по Kafka   | Высокая     | Обучение, наём экспертов                |

## 8. KPI успеха миграции

| Метрика                  | Целевое значение | Текущее значение |
|--------------------------|------------------|------------------|
| Доля потоков на Kafka    | 100%             | 0%               |
| Задержка обработки       | < 1 сек          | > 10 сек         |
| Отказы при маршрутизации | < 0.1%           | ~ 1%             |
| MTTR инцидентов          | < 30 мин         | > 2 часов        |
| Стоимость интеграции     | -30%             | базовое значение |
