# 📊 Credit Portfolio Analytics & Cohort Risk (SQL)

Projeto de análise de risco de crédito em SQL com foco em saúde da carteira, migração de atrasos e cálculo de perda esperada.

## Problema de negócio

Em instituições financeiras, a gestão de risco depende de entender como a carteira evolui ao longo do tempo. A inadimplência não é estática: clientes migram entre grupos de atraso, alguns se recuperam, outros se deterioram e outros entram em perdas definidas.

Sem visão por safra e por roll-rate, a instituição perde capacidade de:

- monitorar qualidade da carteira
- controlar provisões e risco de crédito
- detectar sinais precoces de deterioração
- comparar desempenho por período e segmento

Este projeto foi pensado para trazer visibilidade analítica em SQL para esse cenário.

## O que foi construído

- análise de vintage por contrato e período
- cálculo de cohort risk por atrasos e tempo de permanência
- matriz de roll-rate para migração entre buckets de risco
- estimativa de expected loss (PDD)
- consolidação analítica em queries estruturadas e reutilizáveis

## Metodologia

A análise usa conceitos fundamentais de risco de crédito e SQL analítico:

1. segmentação por safra e tempo de permanência
2. definição de buckets de atraso
3. cálculo de taxa de migração por etapa de risco
4. cálculo de inadimplência acumulada por cohort
5. estimativa de perda esperada usando EAD, PD e LGD

As queries foram estruturadas com CTEs, funções de janela e manipulação temporal para permitir leitura e manutenção fáceis.

## Resultados e KPI

### KPIs e indicadores relevantes

- taxa de inadimplência por cohort
- evolução de 90+ DPD ao longo do tempo
- roll-rate de migração entre buckets
- perda esperada por carteira ou segmento
- performance relativa de safra por período

### Exemplo de leitura de negócio

| Cohort | 30+ DPD | 60+ DPD | 90+ DPD | Observação |
|---|---:|---:|---:|---|
| Jan/2024 | 4.2% | 2.1% | 1.3% | risco estável |
| Mar/2024 | 5.8% | 3.7% | 2.5% | deterioração observada |
| Jun/2024 | 6.9% | 4.9% | 3.1% | atenção à carteira |

Esse tipo de análise é fundamental para tomada de decisão em risco de crédito e gestão de provisionamento.

## Benchmark comparativo

O repositório permite comparar diferentes interpretações da carteira:

- evolução por vintage
- migração por bucket
- impacto do tempo no risco
- risco acumulado vs risco instantâneo

Isso reforça a leitura analítica e ajuda a mostrar maturidade em negócios de crédito e gestão de risco quantitativa.

## Stack

- PostgreSQL
- ANSI SQL
- CTEs
- Window functions
- Funções de data
- Modelagem de risco de crédito

## Estrutura do repositório

```text
credit-cohort-analytics-sql/
├── queries/
├── README.md
├── schema/
├── outputs/
└── notebooks/
```

## Relevância para vagas

Este projeto é especialmente relevante para vagas de:

- Analytics / Reporting
- Risco de crédito
- Modelagem de portfólio
- Data Analysis em finanças
- SQL analítico para negócios
- Gestão de risco e controles internos

## Próximos passos recomendados

- adicionar gráficos de cohort e roll-rate
- comparar carteira por segmento e produto
- conectar com dados reais de crédito
- publicar resumo executivo para stakeholders
- incluir exemplo de provisionamento e PDD em linguagem de negócio

## Link para artigo / benchmark / tabela

- [Painel de cohort risk](#)
- [Relatório de roll-rate](#)
- [Tabela de risco por safra](#)
- [Análise de expected loss](#)

## Mensagem para recrutadores

Este projeto mostra capacidade de trabalhar com dados financeiros complexos, transformar informação em indicadores de risco e apoiar decisões de negócio com uma base analítica sólida. Ele reforça domínio em SQL, análise de portfólio e gestão de risco, com foco em leitura financeira e tomada de decisão.
