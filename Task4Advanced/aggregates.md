# Агрегаты и их границы

## 1. Patient (Медицинский домен - Patient Management)

| Атрибут         | Значение                                                                                |
|-----------------|-----------------------------------------------------------------------------------------|
| Корень агрегата | Patient                                                                                 |
| Идентификатор   | PatientId (UUID)                                                                        |
| Границы         | Инкапсулирует демографические данные, контакты, историю изменений                       |
| Инварианты      | PatientId уникален; email уникален; дата рождения не в будущем; телефон в формате +7XXX |
| Ключи           | PatientId (PK), Inn (альтернативный), Snils (альтернативный)                            |

Вложенные сущности:

- ContactInfo (телефон, email, адрес)
- EmergencyContact

Value Objects:

- FullName (firstName, lastName, patronymic)
- Address (country, city, street, house, apartment)

Доменные события:

- PatientRegistered
- PatientUpdated
- PatientMerged

---

## 2. Appointment (Медицинский домен - Appointment)

| Атрибут         | Значение                                                                                                                                           |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| Корень агрегата | Appointment                                                                                                                                        |
| Идентификатор   | AppointmentId (UUID)                                                                                                                               |
| Границы         | Управляет записью пациента к врачу, статусом, временем                                                                                             |
| Инварианты      | Один пациент не может иметь два активных приёма в одно время; время приёма кратно 15 минутам; нельзя записаться к врачу, если нет свободных слотов |
| Ключи           | AppointmentId (PK), PatientId (FK), DoctorId (FK), ScheduleId (FK)                                                                                 |

Статусы:

- Scheduled (запланирован)
- Confirmed (подтверждён)
- InProgress (в процессе)
- Completed (завершён)
- Cancelled (отменён)
- NoShow (неявка)

Доменные события:

- AppointmentScheduled
- AppointmentConfirmed
- AppointmentCompleted
- AppointmentCancelled
- AppointmentNoShow

---

## 3. MedicalRecord (Медицинский домен - Medical Record)

| Атрибут         | Значение                                                                                               |
|-----------------|--------------------------------------------------------------------------------------------------------|
| Корень агрегата | MedicalRecord                                                                                          |
| Идентификатор   | MedicalRecordId (UUID)                                                                                 |
| Границы         | Содержит полную историю болезни пациента, диагнозы, назначения                                         |
| Инварианты      | Запись может быть только для существующего пациента; изменения логируются; версионирование обязательно |
| Ключи           | MedicalRecordId (PK), PatientId (FK)                                                                   |

Вложенные сущности:

- Diagnosis (диагнозы)
- EpisodeOfCare (эпизоды лечения)
- Observation (наблюдения)

Доменные события:

- MedicalRecordCreated
- DiagnosisAdded
- DiagnosisUpdated
- EpisodeClosed

---

## 4. LabOrder (Медицинский домен - Laboratory)

| Атрибут         | Значение                                                                                        |
|-----------------|-------------------------------------------------------------------------------------------------|
| Корень агрегата | LabOrder                                                                                        |
| Идентификатор   | LabOrderId (UUID)                                                                               |
| Границы         | Управляет заказом лабораторных исследований                                                     |
| Инварианты      | Нельзя изменить заказ после выполнения; результаты могут быть добавлены только после выполнения |
| Ключи           | LabOrderId (PK), PatientId (FK), AppointmentId (FK)                                             |

Статусы:

- Created → Ordered → InProgress → Completed → Cancelled

Доменные события:

- LabOrderCreated
- LabOrderCompleted
- LabResultAvailable

---

## 5. DiagnosticModel (ИИ-домен - Diagnostics)

| Атрибут         | Значение                                                                                       |
|-----------------|------------------------------------------------------------------------------------------------|
| Корень агрегата | DiagnosticModel                                                                                |
| Идентификатор   | ModelId (UUID)                                                                                 |
| Границы         | Управляет версиями ИИ-моделей для диагностики                                                  |
| Инварианты      | Модель должна быть валидирована перед production; версия уникальна; метрики качества >= порога |
| Ключи           | ModelId (PK), Version (SK)                                                                     |

Доменные события:

- ModelTrained
- ModelValidated
- ModelDeployed
- ModelDeprecated

---

## 6. InferenceResult (ИИ-домен - Diagnostics)

| Атрибут         | Значение                                                                                 |
|-----------------|------------------------------------------------------------------------------------------|
| Корень агрегата | InferenceResult                                                                          |
| Идентификатор   | InferenceId (UUID)                                                                       |
| Границы         | Результат применения ИИ-модели к данным пациента                                         |
| Инварианты      | InferenceResult неизменяем после сохранения; ссылается на существующую модель и пациента |
| Ключи           | InferenceId (PK), ModelId (FK), PatientId (FK)                                           |

Доменные события:

- InferenceRequested
- InferenceCompleted
- InferenceFailed

---

## 7. CreditAgreement (Финтех-домен - Credit)

| Атрибут         | Значение                                                                           |
|-----------------|------------------------------------------------------------------------------------|
| Корень агрегата | CreditAgreement                                                                    |
| Идентификатор   | AgreementId (UUID)                                                                 |
| Границы         | Управляет кредитным договором                                                      |
| Инварианты      | Сумма кредита > 0; срок > 0; ставка в разумных пределах; статус только по воркфлоу |
| Ключи           | AgreementId (PK), PatientId (FK), ApplicationId (FK)                               |

Статусы:

- Draft → Pending → Active → Closed → Defaulted

Доменные события:

- CreditAgreementSigned
- CreditAgreementActivated
- PaymentMade
- CreditAgreementClosed
- PaymentMissed

---

## 8. InsurancePolicy (Финтех-домен - Insurance)

| Атрибут         | Значение                                                             |
|-----------------|----------------------------------------------------------------------|
| Корень агрегата | InsurancePolicy                                                      |
| Идентификатор   | PolicyId (UUID)                                                      |
| Границы         | Управляет страховым полисом                                          |
| Инварианты      | Период действия: startDate < endDate; премия > 0; сумма покрытия > 0 |
| Ключи           | PolicyId (PK), PatientId (FK)                                        |

Доменные события:

- PolicyIssued
- PolicyRenewed
- PolicyCancelled
- ClaimFiled
- ClaimSettled

