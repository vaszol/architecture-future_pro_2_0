# Event Storming диаграмма

## Легенда

- 🔵 Команда (Command)
- 🟠 Событие (Event)
- 🟢 Политика/Правило (Policy)
- 🟡 Агрегат (Aggregate) - группа связанных объектов
- 🟣 Внешняя система (External System) - внешний источник/получатель
- ⚪ Актор (Actor) - пользователь или роль


- 🟣 Агрегат (Aggregate)
- ⬛ Внешняя система (External System)

## Схема Event Storming

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              Patient Management Context                                 │
│ ⚪ Patient ──► 🔵 RegisterPatient ──► 🟠 PatientRegistered ──► 🟢 CreateMedicalRecord  │
│                                                                                         │
│ ⚪ Admin ──► 🔵 UpdatePatient ──► 🟠 PatientUpdated ──► 🟢 UpdateAnalytics             │
└─────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PatientRegistered
│ 🟠 PatientUpdated
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Appointment Context                                                │
│ ⚪ Patient ──► 🔵 ScheduleAppointment ──► 🟠 AppointmentScheduled ──► 🟢 CheckAvailability     │
│                                                                                                 │
│ ⚪ Patient ──► 🔵 ConfirmAppointment ──► 🟠 AppointmentConfirmed ──► 🟢 NotifyPatient          │
│                                                                                                 │
│ ⚪ Doctor ──► 🔵 CompleteAppointment ──► 🟠 AppointmentCompleted ──► 🟢 GenerateInvoice        │
│                                                                                                 │
│ ⚪ Patient ──► 🔵 CancelAppointment ──► 🟠 AppointmentCancelled ──► 🟢 RefundPayment           │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 AppointmentCompleted
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Medical Record Context                                             │
│ ⚪ Doctor ──► 🔵 AddDiagnosis ──► 🟠 DiagnosisAdded ──► 🟢 UpdateRiskScore                     │
│                                                       │                                         │
│                                                       ├──► 🟢 CheckInsuranceCoverage            │
│                                                       │                                         │
│                                                       └──► 🟢 UpdateAnalytics                   │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 DiagnosisAdded
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              AI - Diagnostics Context                                           │
│  🟢 DiagnosisAdded ──► 🔵 RequestInference ──► 🟠 InferenceRequested ──► 🟢 ExecuteModel       │
│                                                                                                 │
│  🟢 ExecuteModel ──► 🟠 InferenceCompleted ──► 🟢 StoreResult (Medical Record)                  │
│                                                                                                 │
│                      └──► 🟠 InferenceFailed ──► 🟢 RetryOrFallback                             │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 InferenceCompleted
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              AI - Prediction Context                                            │
│ 🟢 DiagnosisAdded ──► 🔵 CalculateRisk ──► 🟠 RiskScoreCalculated ──► 🟢 EvaluateForInsurance  │
│                                          │                                                      │
│                                          └──► 🟢 UpdateCreditScore (Credit)                     │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 RiskScoreCalculated
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Insurance Context                                                  │
│ ⚪ Customer ──► 🔵 IssuePolicy ──► 🟠 PolicyIssued ──► 🟢 GenerateInvoice                      │
│                                                                                                 │
│ ⚪ Customer ──► 🔵 FileClaim ──► 🟠 ClaimFiled ──► 🟢 ValidateClaim                            │
│                                                                                                 │
│ 🟢 ValidateClaim ──► 🟠 ClaimSettled ──► 🟢 ProcessPayment                                     │
│                                                                                                 │
│ ⚪ Customer ──► 🔵 CancelPolicy ──► 🟠 PolicyCancelled ──► 🟢 RefundPremium                    │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PolicyIssued
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Credit Context                                                     │
│  ⚪ Customer ──► 🔵 ApplyForCredit ──► 🟠 CreditAgreementSigned ──► 🟢 CheckRiskScore          │
│                                                                                                 │
│  🟢 CheckRiskScore ──► 🟠 CreditAgreementActivated ──► 🟢 SetupPaymentSchedule                 │
│                                                                                                 │
│  ⚪ Customer ──► 🔵 MakePayment ──► 🟠 PaymentMade ──► 🟢 UpdateBalance                        │
│                                                                                                 │
│  ⚪ Customer ──► 🔵 CloseAgreement ──► 🟠 CreditAgreementClosed ──► 🟢 UpdateAnalytics         │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PaymentMade
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Payment Context                                                    │
│  🟢 InvoiceGenerated ──► 🔵 InitiatePayment ──► 🟠 PaymentInitiated ──► 🟢 ProcessWithBank     │
│                                                                                                 │
│  🟢 ProcessWithBank ──► 🟠 PaymentCompleted ──► 🟢 UpdateInvoice (Billing)                     │
│                                                                                                 │
│                      └──► 🟠 PaymentFailed ──► 🟢 RetryPayment                                 │
│                                                                                                 │
│  🟢 ProcessWithBank ──► 🟣 External Bank (⬛)                                                  │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PaymentCompleted
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Billing Context                                                    │
│  🟠 AppointmentCompleted ──► 🔵 GenerateInvoice ──► 🟠 InvoiceGenerated ──► 🟢 SendToPatient   │
│                                                                                                 │
│  🟠 PaymentCompleted ──► 🔵 MarkAsPaid ──► 🟠 InvoicePaid ──► 🟢 UpdateAnalytics               │
│                                                                                                 │
│  🔵 CheckOverdue ──► 🟠 InvoiceOverdue ──► 🟢 SendReminder                                     │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ Все события
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Analytics Context                                                  │
│  🟠 Все доменные события ──► 🔵 UpdateMetrics ──► 🟠 KPICalculated ──► 🟢 CheckThresholds      │
│                                                                                                 │
│  🟢 CheckThresholds ──► 🟠 AlertTriggered ──► 🟢 NotifyTeam                                    │
│                                                                                                 │
│  ⚪ Analyst ──► 🔵 GenerateReport ──► 🟠 ReportGenerated ──► 🟢 DeliverToUser                  │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Сводная таблица потоков событий

| Событие               | Источник           | Получатели                | Тип взаимодействия |
|-----------------------|--------------------|---------------------------|--------------------|
| PatientRegistered     | Patient Management | Medical Record, Analytics | Асинхронный        |
| AppointmentCompleted  | Appointment        | Billing, Analytics        | Асинхронный        |
| DiagnosisAdded        | Medical Record     | AI, Insurance, Analytics  | Асинхронный        |
| InferenceCompleted    | AI                 | Medical Record, Analytics | Асинхронный        |
| RiskScoreCalculated   | AI                 | Insurance, Credit         | Асинхронный        |
| PolicyIssued          | Insurance          | Billing, Analytics        | Асинхронный        |
| CreditAgreementSigned | Credit             | Analytics, Billing        | Асинхронный        |
| PaymentCompleted      | Payment            | Billing, Analytics        | Асинхронный        |
| InvoiceGenerated      | Billing            | Analytics                 | Асинхронный        |

