# Ideia Inicial do Projeto

**Objetivo**:  
Construir um sistema de detecção de anomalias em transações do blockchain Bitcoin usando apenas recursos gratuitos do Google Cloud (BigQuery Sandbox), para adicionar ao portfólio como Analytics Engineer / Data Engineer.

**Escopo original planejado**:
- Usar o dataset público `bigquery-public-data.crypto_bitcoin.transactions`
- dbt para transformar dados: models diários de volume, endereços ativos e features de padrões suspeitos (mixing, high value, high I/O count, fee ratio)
- BigQuery ML para anomaly detection não supervisionado (Autoencoder ou K-Means)
- Looker Studio para dashboard com gráficos de transações e alertas visuais de possíveis fraudes

**Adaptação devido a limitações do BigQuery Sandbox**:
- Limite de 10 GB de storage impediu o treinamento de modelos BQML permanentes
- Solução final: detecção rule-based avançada com APPROX_QUANTILES para thresholds dinâmicos (top 1-5%) + anomaly_score composto
- Resultado: mais explicável, leve e totalmente funcional no ambiente gratuito

**Resultado alcançado**:
- Pipeline dbt completo com staging e features
- View de anomalias rule-based detectando mixing, transações gigantes e fees suspeitas
- Dashboard interativo no Looker Studio
- Documentação dbt hospedada automaticamente no GitHub Pages
- 100% gratuito e reproduzível