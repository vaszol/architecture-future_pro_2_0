# Bounded Contexts диаграмма

## Текстовая схема bounded contexts

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              Медицинский домен (Medical Domain)                          │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐              │
│  │  Patient Management │  │  Appointment Context │  │  Medical Record     │              │
│  │  (Управление        │  │  (Запись к врачу)    │  │  Context            │              │
│  │  пациентами)        │  │                      │  │  (Медкарты)         │              │
│  │                     │  │  Агрегаты:           │  │                     │              │
│  │  Агрегаты:          │  │  - Appointment       │  │  Агрегаты:          │              │
│  │  - Patient          │  │  - Schedule          │  │  - MedicalRecord     │              │
│  │  - PatientHistory   │  │  - DoctorSchedule    │  │  - Diagnosis        │              │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘              │
│  ┌─────────────────────┐  ┌─────────────────────┐                                      │
│  │  Laboratory Context │  │  Prescription       │                                      │
│  │  (Лаборатория)      │  │  Context            │                                      │
│  │                     │  │  (Назначения)       │                                      │
│  │  Агрегаты:          │  │                     │                                      │
│  │  - LabOrder         │  │  Агрегаты:          │                                      │
│  │  - LabResult        │  │  - Prescription     │                                      │
│  └─────────────────────┘  └─────────────────────┘                                      │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                                          │
                                          │ События
                                          ▼

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              ИИ-домен (AI Domain)                                        │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐              │
│  │  Diagnostics Context│  │  Prediction Context │  │  Recommendation    │              │
│  │  (Диагностика)      │  │  (Предиктивная      │  │  Context           │              │
│  │                     │  │   аналитика)        │  │  (Рекомендации)    │              │
│  │  Агрегаты:          │  │                     │  │                    │              │
│  │  - DiagnosticModel  │  │  Агрегаты:          │  │  Агрегаты:         │              │
│  │  - InferenceResult  │  │  - RiskScore        │  │  - Recommendation  │              │
│  │  - TrainingJob      │  │  - HealthForecast   │  │  - TreatmentSuggestion│            │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                                          │
                                          │ События
                                          ▼

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              Финтех-домен (Fintech Domain)                               │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐              │
│  │  Payment Context    │  │  Credit Context     │  │  Insurance Context │              │
│  │  (Платежи)          │  │  (Кредиты)          │  │  (Страхование)     │              │
│  │                     │  │                     │  │                    │              │
│  │  Агрегаты:          │  │  Агрегаты:          │  │  Агрегаты:         │              │
│  │  - Payment          │  │  - CreditAgreement  │  │  - InsurancePolicy │              │
│  │  - Transaction      │  │  - LoanApplication  │  │  - Claim           │              │
│  │  - Account          │  │  - RepaymentSchedule│  │  - Premium         │              │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘              │
│  ┌─────────────────────┐                                                              │
│  │  Billing Context    │                                                              │
│  │  (Биллинг)          │                                                              │
│  │                     │                                                              │
│  │  Агрегаты:          │                                                              │
│  │  - Invoice          │                                                              │
│  │  - Subscription     │                                                              │
│  └─────────────────────┘                                                              │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                                          │
                                          │ События
                                          ▼

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           Аналитический домен (Analytics Domain)                         │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐              │
│  │  Reporting Context  │  │  Metrics Context    │  │  Dashboard Context  │              │
│  │  (Отчётность)       │  │  (Метрики)          │  │  (Дашборды)         │              │
│  │                     │  │                     │  │                    │              │
│  │  Агрегаты:          │  │  Агрегаты:          │  │  Агрегаты:         │              │
│  │  - Report           │  │  - BusinessMetric   │  │  - Dashboard       │              │
│  │  - Schedule         │  │  - KPI              │  │  - Widget          │              │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

## Bounded contexts в виде таблицы

| Домен     | Bounded Context    | Описание                      | Агрегаты                                            |
|-----------|--------------------|-------------------------------|-----------------------------------------------------|
| Medical   | Patient Management | Управление данными пациентов  | Patient, PatientHistory                             |
| Medical   | Appointment        | Запись к врачу, расписание    | Appointment, Schedule, DoctorSchedule               |
| Medical   | Medical Record     | Электронные медицинские карты | MedicalRecord, Diagnosis                            |
| Medical   | Laboratory         | Лабораторные исследования     | LabOrder, LabResult                                 |
| Medical   | Prescription       | Назначения и рецепты          | Prescription                                        |
| AI        | Diagnostics        | ИИ-диагностика                | DiagnosticModel, InferenceResult, TrainingJob       |
| AI        | Prediction         | Предиктивная аналитика        | RiskScore, HealthForecast                           |
| AI        | Recommendation     | Рекомендации по лечению       | Recommendation, TreatmentSuggestion                 |
| Fintech   | Payment            | Платежи и транзакции          | Payment, Transaction, Account                       |
| Fintech   | Credit             | Кредитные продукты            | CreditAgreement, LoanApplication, RepaymentSchedule |
| Fintech   | Insurance          | Страхование                   | InsurancePolicy, Claim, Premium                     |
| Fintech   | Billing            | Биллинг и подписки            | Invoice, Subscription                               |
| Analytics | Reporting          | Формирование отчётов          | Report, Schedule                                    |
| Analytics | Metrics            | Бизнес-метрики                | BusinessMetric, KPI                                 |
| Analytics | Dashboard          | Дашборды                      | Dashboard, Widget                                   |


