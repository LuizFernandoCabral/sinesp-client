# Sinesp-Client

## Agradecimentos
###### Versão ruby para https://github.com/victor-torres/sinesp-client
###### Agradecimentos ao mesmo, por favor refenciar acima

## O que é o SINESP

SINESP Cidadão é uma base de dados pública de veículos brasileiros. É muito útil para identificar carros ou motos roubados ou suspeitos.


## Informações disponíveis

Se um veículo com a placa especificada for encontrado, o servidor irá retornar as seguintes informações que serão repassadas através de um dicionário:

- return_code (código de retorno)
- return_message (mensagem de retorno)
- status_code (código do status)
- status_message (mensagem do status)
- chassis (chassi do veículo)
- model (modelo/versão)
- brand (marca/fabricante)
- color (cor/pintura)
- year (ano de fabricação)
- model_year (ano do modelo)
- plate (placa)
- date (data e hora da consulta)
- city (cidade)
- state (estado ou unidade federativa)


## Por que fazer um cliente do SINESP?

Não sabemos o porquê, mas o governo não mantém uma API pública para este serviço. A única maneira de acessar os dados é acessando o site do SINESP e respondendo a perguntas de verificação (captchas) para cada uma das requisições.

### Utilização normal

```ruby
require 'sinesp_client'
sc = SinespClient.new
result = sc.search('ABC1234')
```

## Autor
Vide Agradecimentos
- Luiz Fernando P. L. Cabral [@Luiz-Fernando-Cabral](https://github.com/LuizFernandoCabral)
