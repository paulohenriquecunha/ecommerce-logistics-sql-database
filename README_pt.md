# Projeto de Base de Dados – E-commerce

Este projeto implementa um banco de dados relacional completo para um sistema de **e-commerce**, incluindo clientes, endereços, produtos, categorias, armazéns, inventário, pedidos, itens, pagamentos, transportadoras e envios.

---

## Estrutura do Projeto

| Arquivo | Descrição |
|----------|------------|
| **01_schema.sql** | Criação do schema `ecommerce_db`, tabelas, chaves estrangeiras e *triggers* automáticos. |
| **02_seed_data.sql** | Inserção de dados fictícios (~1.200 registros) com nomes realistas e relações coerentes. |
| **03_validation_checks.sql** | Script de verificação da integridade e consistência dos dados. |

---

## Entidades Principais

- **customers** – informações dos clientes.  
- **addresses** – endereços de cobrança e envio.  
- **categories** – categorias de produtos.  
- **products** – produtos com SKU, preço e categoria.  
- **warehouses** – armazéns de estoque.  
- **inventory** – controle de quantidades e estoque de segurança.  
- **orders** – pedidos de clientes.  
- **order_items** – itens de cada pedido.  
- **payments** – pagamentos realizados.  
- **carriers** – transportadoras.  
- **shipments** – registros de envio.

---

## Como Executar

1. Crie o banco de dados:
   SOURCE C:/TEMP/01_schema.sql;

2. Insira os dados fictícios:
SOURCE C:/TEMP/02_seed_data.sql;

3. Valide a integridade:
SOURCE C:/TEMP/03_validation_checks.sql;

---

## Verificação de Integridade
O script de validação (03_validation_checks.sql) executa verificações automáticas:
* Contagem de linhas por tabela
* Chaves estrangeiras órfãs
* Campos obrigatórios nulos
* Duplicações de e-mail e SKU
* Pedidos sem itens ou sem pagamentos
* Coerência entre status de pedidos, pagamentos e envios
* Estoques negativos
* Datas fora do intervalo esperado
* Formato de e-mail
* Resumo por status e método de pagamento

Se todas as verificações retornarem 0 violações, os dados foram carregados corretamente.

---

## Observações Técnicas
* Compatível com MySQL 8+.
* Todos os triggers e constraints foram testados para evitar inconsistências.
* Os dados fictícios foram gerados com base em distribuições realistas de preços, datas e categorias.
* Pode ser usado como base para projetos de Power BI, ETL/EDA e análise de vendas.

---

## Autor
**Paulo Henrique P. Cunha**
Analista de Dados | Desenvolvedor Web
LinkedIn: www.linkedin.com/in/paulo-henrique-p-cunha/