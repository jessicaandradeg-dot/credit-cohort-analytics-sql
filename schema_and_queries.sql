-- PROJETO : ANÁLISE DE CARTEIRA DE CRÉDITO, COORTES E ROLL-RATES
-- Dialeto: PostgreSQL / ANSI SQL
-- Autora: Jéssica Andrade (UFRJ/COPPE)

CREATE TABLE IF NOT EXISTS loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    issue_date DATE NOT NULL,
    original_amount NUMERIC(12, 2) NOT NULL,
    interest_rate NUMERIC(5, 4) NOT NULL,
    term_months INT NOT NULL
);

CREATE TABLE IF NOT EXISTS loan_monthly_performance (
    performance_id SERIAL PRIMARY KEY,
    loan_id VARCHAR(20) REFERENCES loans(loan_id),
    reference_month DATE NOT NULL,
    days_past_due INT NOT NULL,
    outstanding_balance NUMERIC(12, 2) NOT NULL,
    amount_paid NUMERIC(12, 2) DEFAULT 0.0
);

-- CONSULTA 1: ANÁLISE DE SAFRA / COORTE DE INADIMPLÊNCIA (VINTAGE 90+ DPD)
WITH loan_cohorts AS (
    SELECT 
        l.loan_id,
        DATE_TRUNC('month', l.issue_date)::DATE AS issue_cohort,
        p.reference_month,
        (EXTRACT(YEAR FROM p.reference_month) - EXTRACT(YEAR FROM l.issue_date)) * 12 +
        (EXTRACT(MONTH FROM p.reference_month) - EXTRACT(MONTH FROM l.issue_date)) AS mob,
        l.original_amount,
        p.outstanding_balance,
        p.days_past_due,
        CASE WHEN p.days_past_due >= 90 THEN 1 ELSE 0 END AS is_default_90
    FROM loans l
    JOIN loan_monthly_performance p ON l.loan_id = p.loan_id
),
cohort_summary AS (
    SELECT 
        issue_cohort,
        mob,
        COUNT(DISTINCT loan_id) AS total_contracts,
        SUM(original_amount) AS total_volume_originated,
        SUM(CASE WHEN is_default_90 = 1 THEN outstanding_balance ELSE 0 END) AS default_balance_90
    FROM loan_cohorts
    GROUP BY issue_cohort, mob
)
SELECT 
    issue_cohort,
    mob,
    total_contracts,
    total_volume_originated,
    default_balance_90,
    ROUND((default_balance_90 / NULLIF(total_volume_originated, 0)) * 100, 2) AS default_rate_pct
FROM cohort_summary
WHERE mob IN (3, 6, 12, 18, 24)
ORDER BY issue_cohort DESC, mob ASC;

-- CONSULTA 2: MATRIZ DE ROLL-RATE (MIGRAÇÃO DE FAIXAS DE ATRASO M-1 PARA M)
WITH status_transition AS (
    SELECT 
        p1.loan_id,
        p1.reference_month AS current_month,
        CASE 
            WHEN p1.days_past_due = 0 THEN '01_Adimplente'
            WHEN p1.days_past_due BETWEEN 1 AND 30 THEN '02_1-30 DPD'
            WHEN p1.days_past_due BETWEEN 31 AND 60 THEN '03_31-60 DPD'
            WHEN p1.days_past_due BETWEEN 61 AND 90 THEN '04_61-90 DPD'
            ELSE '05_90+ DPD'
        END AS bucket_previous,
        CASE 
            WHEN p2.days_past_due = 0 THEN '01_Adimplente'
            WHEN p2.days_past_due BETWEEN 1 AND 30 THEN '02_1-30 DPD'
            WHEN p2.days_past_due BETWEEN 31 AND 60 THEN '03_31-60 DPD'
            WHEN p2.days_past_due BETWEEN 61 AND 90 THEN '04_61-90 DPD'
            ELSE '05_90+ DPD'
        END AS bucket_current,
        p2.outstanding_balance
    FROM loan_monthly_performance p1
    JOIN loan_monthly_performance p2 
        ON p1.loan_id = p2.loan_id 
       AND p2.reference_month = p1.reference_month + INTERVAL '1 month'
)
SELECT 
    bucket_previous,
    bucket_current,
    COUNT(loan_id) AS total_loans,
    SUM(outstanding_balance) AS total_balance_brl,
    ROUND(
        COUNT(loan_id)::NUMERIC / SUM(COUNT(loan_id)) OVER(PARTITION BY bucket_previous) * 100, 
        2
    ) AS transition_rate_pct
FROM status_transition
GROUP BY bucket_previous, bucket_current
ORDER BY bucket_previous, bucket_current;

-- CONSULTA 3: PROVISÃO PARA PERDA ESPERADA (PDD / EXPECTED LOSS)
WITH portfolio_risk_exposure AS (
    SELECT 
        loan_id,
        reference_month,
        outstanding_balance AS ead,
        days_past_due,
        CASE 
            WHEN days_past_due = 0 THEN 0.02
            WHEN days_past_due BETWEEN 1 AND 30 THEN 0.15
            WHEN days_past_due BETWEEN 31 AND 60 THEN 0.45
            WHEN days_past_due BETWEEN 61 AND 90 THEN 0.75
            ELSE 1.00
        END AS estimated_pd,
        0.60 AS estimated_lgd
    FROM loan_monthly_performance
    WHERE reference_month = (SELECT MAX(reference_month) FROM loan_monthly_performance)
)
SELECT 
    reference_month,
    COUNT(loan_id) AS active_loans,
    SUM(ead) AS total_portfolio_balance_brl,
    SUM(ead * estimated_pd * estimated_lgd) AS total_pdd_provision_brl,
    ROUND((SUM(ead * estimated_pd * estimated_lgd) / SUM(ead)) * 100, 2) AS portfolio_loss_provision_pct
FROM portfolio_risk_exposure
GROUP BY reference_month;
