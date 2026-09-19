# 📊 Financial Credit Portfolio Analytics & Cohort Risk (SQL)

Advanced SQL analytical suite designed for retail credit portfolio management, vintage cohort tracking, roll-rate migration matrices, and regulatory Expected Loss (PDD) calculations.

---

## 🎯 Contexto de Negócio

Em instituições de grande porte como o **Itaú**, o acompanhamento contínuo da saúde da carteira de crédito exige métricas de risco consolidadas por safra (*vintage*) e modelo de migração de atrasos (*roll-rates*). Este repositório contém queries em SQL de alta performance projetadas para:

1. **Vintage / Cohort Analysis:** Acompanhar a evolução da inadimplência ($90+$ DPD) ao longo do tempo de vida do contrato (MOB - *Month On Book*).
2. **Matriz de Roll-Rate:** Avaliar a probabilidade de um cliente em atraso leve ($1-30$ dias) migrar para perdas definitivas ($90+$ dias) versus recuperar a adimplência.
3. **Cálculo de PDD (Expected Loss):** Estimativa da Provisão para Devedores Duvidosos combinando *Exposure at Default* (EAD), *Probability of Default* (PD) e *Loss Given Default* (LGD).

---

## 🛠️ Tecnologias e Conceitos SQL Utilizados

* **CTEs (Common Table Expressions):** Estruturação modular de subqueries complexas.
* **Window Functions:** `SUM() OVER(PARTITION BY ...)` para cálculo de taxas de migração.
* **Interval Arithmetic & Date Functions:** Normalização de datas de safra via `DATE_TRUNC()`.

---

## 📧 Autora
* **Jéssica Andrade** — Doutoranda em Engenharia Biomédica (UFRJ/COPPE)
* **E-mail:** `jessicaandradeg@peb.ufrj.br`
* **GitHub:** [jessicaandradeg-dot](https://github.com/jessicaandradeg-dot)