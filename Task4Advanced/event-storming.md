# Event Storming диаграмма

## Легенда

- 🔵 Команда (Command)
- 🟠 Событие (Event)
- 🟢 Политика/Правило (Policy)
- 🟣 Агрегат (Aggregate)
- ⬛ Внешняя система (External System)

## Схема Event Storming

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Patient Management Context                                         │
│  🔵 RegisterPatient ──► 🟠 PatientRegistered ──► 🟢 CreateMedicalRecord                         │
│                                                                                                 │
│  🔵 UpdatePatient ──► 🟠 PatientUpdated ──► 🟢 UpdateAnalytics                                  │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PatientRegistered
│ 🟠 PatientUpdated
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Appointment Context                                                │
│  🔵 ScheduleAppointment ──► 🟠 AppointmentScheduled ──► 🟢 CheckAvailability                     │
│                                                                                                 │
│  🔵 ConfirmAppointment ──► 🟠 AppointmentConfirmed ──► 🟢 NotifyPatient                          │
│                                                                                                 │
│  🔵 CompleteAppointment ──► 🟠 AppointmentCompleted ──► 🟢 GenerateInvoice (Billing)            │
│                                                                                                 │
│  🔵 CancelAppointment ──► 🟠 AppointmentCancelled ──► 🟢 RefundPayment (Payment)                │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 AppointmentCompleted
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Medical Record Context                                             │
│  🔵 AddDiagnosis ──► 🟠 DiagnosisAdded ──► 🟢 UpdateRiskScore (AI)                              │
│                                          │                                                      │
│                                          ├──► 🟢 CheckInsuranceCoverage (Insurance)             │
│                                          │                                                      │
│                                          └──► 🟢 UpdateAnalytics                               │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 DiagnosisAdded
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              AI - Diagnostics Context                                           │
│  🔵 RequestInference ──► 🟠 InferenceRequested ──► 🟢 ExecuteModel                              │
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
│  🔵 CalculateRisk ──► 🟠 RiskScoreCalculated ──► 🟢 EvaluateForInsurance                        │
│                                                                                                 │
│                      └──► 🟢 UpdateCreditScore (Credit)                                         │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 RiskScoreCalculated
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Insurance Context                                                 │
│  🔵 IssuePolicy ──► 🟠 PolicyIssued ──► 🟢 GenerateInvoice (Billing)                           │
│                                                                                                 │
│  🔵 FileClaim ──► 🟠 ClaimFiled ──► 🟢 ValidateClaim                                            │
│                                                                                                 │
│  🟢 ValidateClaim ──► 🟠 ClaimSettled ──► 🟢 ProcessPayment (Payment)                           │
│                                                                                                 │
│  🔵 CancelPolicy ──► 🟠 PolicyCancelled ──► 🟢 RefundPremium (Payment)                          │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PolicyIssued
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Credit Context                                                    │
│  🔵 ApplyForCredit ──► 🟠 CreditAgreementSigned ──► 🟢 CheckRiskScore (AI)                     │
│                                                                                                 │
│  🟢 CheckRiskScore ──► 🟠 CreditAgreementActivated ──► 🟢 SetupPaymentSchedule                  │
│                                                                                                 │
│  🔵 MakePayment ──► 🟠 PaymentMade ──► 🟢 UpdateBalance                                         │
│                                                                                                 │
│  🔵 CloseAgreement ──► 🟠 CreditAgreementClosed ──► 🟢 UpdateAnalytics                          │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PaymentMade
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Payment Context                                                   │
│  🔵 InitiatePayment ──► 🟠 PaymentInitiated ──► 🟢 ProcessWithBank (⬛ External Bank)          │
│                                                                                                 │
│  🟢 ProcessWithBank ──► 🟠 PaymentCompleted ──► 🟢 UpdateInvoice (Billing)                      │
│                                                                                                 │
│                      └──► 🟠 PaymentFailed ──► 🟢 RetryPayment                                  │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ 🟠 PaymentCompleted
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Billing Context                                                   │
│  🔵 GenerateInvoice ──► 🟠 InvoiceGenerated ──► 🟢 SendToPatient                                │
│                                                                                                 │
│  🔵 MarkAsPaid ──► 🟠 InvoicePaid ──► 🟢 UpdateAnalytics                                        │
│                                                                                                 │
│  🔵 CheckOverdue ──► 🟠 InvoiceOverdue ──► 🟢 SendReminder                                      │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
│
│ Все события
▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              Analytics Context                                                 │
│  🟠 Все доменные события ──► 🟢 UpdateMetrics ──► 🟠 KPICalculated                              │
│                                                                                                 │
│  🟢 UpdateMetrics ──► 🟠 KPICalculated ──► 🟢 CheckThresholds                                   │
│                                                                                                 │
│  🟢 CheckThresholds ──► 🟠 AlertTriggered ──► 🟢 NotifyTeam                                      │
│                                                                                                 │
│  🔵 GenerateReport ──► 🟠 ReportGenerated ──► 🟢 DeliverToUser                                   │
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

