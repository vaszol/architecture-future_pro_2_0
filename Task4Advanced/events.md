# Каталог доменных событий

## Медицинский домен (Medical Domain)

### Patient Management Context

| Событие           | Источник           | Подписчики                          | Контракт                                                        |
|-------------------|--------------------|-------------------------------------|-----------------------------------------------------------------|
| PatientRegistered | Patient Management | Appointment, MedicalRecord, Billing | `{ patientId, fullName, birthDate, contactInfo, registeredAt }` |
| PatientUpdated    | Patient Management | Analytics, Billing                  | `{ patientId, changedFields, updatedAt }`                       |
| PatientMerged     | Patient Management | Все домены                          | `{ sourcePatientId, targetPatientId, mergedAt }`                |

### Appointment Context

| Событие              | Источник    | Подписчики                        | Контракт                                                           |
|----------------------|-------------|-----------------------------------|--------------------------------------------------------------------|
| AppointmentScheduled | Appointment | MedicalRecord, Billing, Analytics | `{ appointmentId, patientId, doctorId, scheduledTime, specialty }` |
| AppointmentConfirmed | Appointment | MedicalRecord                     | `{ appointmentId, confirmedAt }`                                   |
| AppointmentCompleted | Appointment | MedicalRecord, Billing, Analytics | `{ appointmentId, completedAt, duration }`                         |
| AppointmentCancelled | Appointment | MedicalRecord, Billing            | `{ appointmentId, cancelledAt, reason, cancelledBy }`              |
| AppointmentNoShow    | Appointment | Billing, Analytics                | `{ appointmentId, patientId, noShowAt }`                           |

### Medical Record Context

| Событие              | Источник       | Подписчики               | Контракт                                                            |
|----------------------|----------------|--------------------------|---------------------------------------------------------------------|
| MedicalRecordCreated | Medical Record | AI, Analytics            | `{ recordId, patientId, createdAt }`                                |
| DiagnosisAdded       | Medical Record | AI, Insurance, Analytics | `{ recordId, diagnosisCode, diagnosisName, diagnosedAt, doctorId }` |
| DiagnosisUpdated     | Medical Record | AI, Analytics            | `{ recordId, diagnosisId, oldCode, newCode, updatedAt }`            |
| EpisodeClosed        | Medical Record | Analytics                | `{ recordId, episodeId, closedAt, outcome }`                        |

### Laboratory Context

| Событие            | Источник   | Подписчики                | Контракт                                                                    |
|--------------------|------------|---------------------------|-----------------------------------------------------------------------------|
| LabOrderCreated    | Laboratory | Medical Record, Analytics | `{ orderId, patientId, testType, orderedAt, priority }`                     |
| LabOrderCompleted  | Laboratory | Medical Record            | `{ orderId, completedAt, results }`                                         |
| LabResultAvailable | Laboratory | AI, Medical Record        | `{ orderId, patientId, testType, resultValue, referenceRange, measuredAt }` |

### Prescription Context

| Событие            | Источник     | Подписчики                   | Контракт                                                                  |
|--------------------|--------------|------------------------------|---------------------------------------------------------------------------|
| PrescriptionIssued | Prescription | Pharmacy, Billing, Analytics | `{ prescriptionId, patientId, medication, dosage, issuedAt, validUntil }` |
| PrescriptionFilled | Prescription | Medical Record               | `{ prescriptionId, filledAt, pharmacyId }`                                |

## ИИ-домен (AI Domain)

### Diagnostics Context

| Событие            | Источник    | Подписчики                | Контракт                                                                 |
|--------------------|-------------|---------------------------|--------------------------------------------------------------------------|
| InferenceRequested | Diagnostics | AI Engine                 | `{ inferenceId, patientId, modelId, inputData, requestedAt }`            |
| InferenceCompleted | Diagnostics | Medical Record, Analytics | `{ inferenceId, patientId, modelId, result, confidence, completedAt }`   |
| InferenceFailed    | Diagnostics | Monitoring                | `{ inferenceId, patientId, modelId, errorCode, errorMessage, failedAt }` |
| ModelDeployed      | Diagnostics | All domains               | `{ modelId, version, deployedAt, metrics }`                              |

### Prediction Context

| Событие                 | Источник   | Подписчики                | Контракт                                                          |
|-------------------------|------------|---------------------------|-------------------------------------------------------------------|
| RiskScoreCalculated     | Prediction | Insurance, Medical Record | `{ patientId, riskScore, riskFactors, calculatedAt, validUntil }` |
| HealthForecastGenerated | Prediction | Analytics                 | `{ patientId, forecast, timeHorizon, generatedAt }`               |

### Recommendation Context

| Событие                      | Источник       | Подписчики     | Контракт                                                                    |
|------------------------------|----------------|----------------|-----------------------------------------------------------------------------|
| TreatmentSuggestionGenerated | Recommendation | Medical Record | `{ patientId, diagnosisCode, suggestedTreatment, confidence, generatedAt }` |
| RecommendationAccepted       | Recommendation | Analytics      | `{ recommendationId, patientId, doctorId, acceptedAt }`                     |

## Финтех-домен (Fintech Domain)

### Payment Context

| Событие          | Источник | Подписчики         | Контракт                                                                 |
|------------------|----------|--------------------|--------------------------------------------------------------------------|
| PaymentInitiated | Payment  | Billing            | `{ paymentId, patientId, amount, currency, paymentMethod, initiatedAt }` |
| PaymentCompleted | Payment  | Billing, Analytics | `{ paymentId, patientId, amount, completedAt, transactionId }`           |
| PaymentFailed    | Payment  | Billing            | `{ paymentId, patientId, amount, errorCode, failedAt }`                  |
| RefundProcessed  | Payment  | Billing            | `{ refundId, originalPaymentId, amount, processedAt }`                   |

### Credit Context

| Событие                  | Источник | Подписчики             | Контракт                                                                        |
|--------------------------|----------|------------------------|---------------------------------------------------------------------------------|
| CreditAgreementSigned    | Credit   | Analytics, Billing     | `{ agreementId, patientId, amount, term, interestRate, signedAt }`              |
| CreditAgreementActivated | Credit   | Payment, Analytics     | `{ agreementId, patientId, activatedAt, firstPaymentDue }`                      |
| PaymentMade              | Credit   | Payment, Analytics     | `{ agreementId, paymentId, amount, paymentDate, remainingBalance }`             |
| CreditAgreementClosed    | Credit   | Analytics              | `{ agreementId, patientId, closedAt, totalPaid, finalStatus }`                  |
| PaymentMissed            | Credit   | Analytics, Collections | `{ agreementId, patientId, missedPaymentDate, daysOverdue, outstandingAmount }` |

### Insurance Context

| Событие         | Источник  | Подписчики              | Контракт                                                                         |
|-----------------|-----------|-------------------------|----------------------------------------------------------------------------------|
| PolicyIssued    | Insurance | Billing, Medical Record | `{ policyId, patientId, type, coverage, premium, startDate, endDate, issuedAt }` |
| PolicyRenewed   | Insurance | Billing                 | `{ policyId, patientId, newEndDate, renewedAt, premium }`                        |
| PolicyCancelled | Insurance | Analytics               | `{ policyId, patientId, cancelledAt, reason }`                                   |
| ClaimFiled      | Insurance | Medical Record          | `{ claimId, policyId, patientId, amount, incidentDate, filedAt }`                |
| ClaimSettled    | Insurance | Payment, Analytics      | `{ claimId, policyId, patientId, approvedAmount, settledAt }`                    |

### Billing Context

| Событие          | Источник | Подписчики         | Контракт                                                        |
|------------------|----------|--------------------|-----------------------------------------------------------------|
| InvoiceGenerated | Billing  | Payment, Analytics | `{ invoiceId, patientId, amount, dueDate, items, generatedAt }` |
| InvoicePaid      | Billing  | Analytics          | `{ invoiceId, patientId, paidAt, amount }`                      |
| InvoiceOverdue   | Billing  | Collections        | `{ invoiceId, patientId, dueDate, overdueDays, amount }`        |

## Аналитический домен (Analytics Domain)

| Событие         | Источник  | Подписчики   | Контракт                                                                 |
|-----------------|-----------|--------------|--------------------------------------------------------------------------|
| ReportGenerated | Reporting | Dashboard    | `{ reportId, type, period, generatedAt, data }`                          |
| KPICalculated   | Metrics   | Dashboard    | `{ metricId, name, value, target, calculatedAt, period }`                |
| AlertTriggered  | Metrics   | Notification | `{ alertId, metricName, actualValue, threshold, triggeredAt, severity }` |

