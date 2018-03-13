# Sinesp-Client

## Agradecimentos
###### Versão ruby para https://github.com/victor-torres/sinesp-client
###### Agradecimentos ao mesmo, por favor refenciar acima

## O que é o SINESP

SINESP Cidadão é uma base de dados pública de veículos brasileiros. É muito útil para identificar carros ou motos roubados ou suspeitos.


## Informações disponíveis

Se um veículo com a placa especificada for encontrado, o servidor irá retornar as seguintes informações que serão repassadas através de um dicionário:
- data
  - codigoRetorno (código de retorno)
  - mensagemRetorno (mensagem de retorno)
  - codigoSituacao (código do status)
  - situacao (mensagem do status)
  - chassi ('************xxxxx' - apenas últimos 5 dígitos)
  - modelo
  - marca
  - cor
  - ano (de fabricação)
  - anoModelo (do modelo)
  - placa
  - data (data e hora da consulta)
  - municipio
  - uf
- plain_response
  - objeto HTTPart::Response crú


## Por que fazer um cliente do SINESP?

Não sabemos o porquê, mas o governo não mantém uma API pública para este serviço. A única maneira de acessar os dados é acessando o site do SINESP e respondendo a perguntas de verificação (captchas) para cada uma das requisições.

### Utilização normal

```ruby
require 'sinesp_client'

sc = SinespClient.new
result = sc.search('ABC1234')
```

### Com proxy

O SINESP pode bloquear conexões vindas de fora do país. Se acontecer de você estar enfrentando problemas de conexões você pode tentar utilizar um web proxy (SOCKS5), que podem ser encontrados gratuitamente na Internet.

```ruby
require 'sinesp_client'

proxies_options = {
  'proxy_address' => '127.0.0.1',
  'proxy_port' => 8080,
  'proxy_user' =>  'user',
  'proxy_pwd' => 'password'
}
sc = SinespClient.new(proxies_options)
result = sc.search('ABC1234')
```

## Autor
Vide [Agradecimentos](https://github.com/LuizFernandoCabral/sinesp-client#agradecimentos)
- Luiz Fernando P. L. Cabral [@Luiz-Fernando-Cabral](https://github.com/LuizFernandoCabral)
