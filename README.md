# PopMenuApi

Uma aplicação para gerenciar restaurantes, menus e itens de menu, com suporte a importação de dados via API.

---

### 🔹 Descrição do Projeto
Esta aplicação permite:
- Criar e listar restaurantes, menus e itens de menu.
- Validar dados de restaurantes, menus e itens antes da importação.
- Importar dados via API, retornando relatórios de sucesso e falha.


### 🔹 Tecnologias Utilizadas

- Ruby 3.x
- Ruby on Rails 7.x
- PostgreSQL
- RSpec / FactoryBot para testes

---

### 🔹 Setup do Projeto

Clone o repositório:

```bash
git clone git@github.com:juliaportella/PopMenuApi.git
cd PopMenuApi
```

Acesse o container docker: 
```bash
docker compose run --rm web bash
ou
docker-compose run --rm web bash
```
Rode os seguintes comandos: 
```bash
rails db:create
rails db:migrate
```

---

### 📌 Rotas disponíveis
#### Restaurantes
- GET `/api/restaurants` → Lista todos os restaurantes
- GET `/api/restaurants/:id` → Mostra um restaurante específico
- POST `/api/restaurants` → Cria um novo restaurante
- PUT `/api/restaurants/:id` → Atualiza um restaurante
- DELETE `/api/restaurants/:id` → Remove um restaurante

#### Menus
- GET `/api/restaurants/:restaurant_id/menus` → Lista menus de um restaurante
- POST `/api/restaurants/:restaurant_id/menus` → Cria um menu para o restaurante

#### Itens de Menu
- GET `/api/restaurants/:restaurant_id/menus/:menu_id/menu_items` → Lista itens de um menu
- POST `/api/restaurants/:restaurant_id/menus/:menu_id/menu_items` → Cria um item de menu

---

### 📥 Rota de Importação

Permite importar restaurantes, menus e itens em massa via JSON.

#### Endpoint
POST `/api/importation`

#### Exemplo de payload
```bash
{
  "restaurants": [
    {
      "name": "Poppo's Cafe",
      "menus": [
        {
            "name": "lunch",
            "menu_items": [
              {
                "name": "Burger",
                "price": "9.0"
              },
              {
                "name": "Small Salad",
                "price": "5.0"
              }
            ]
          },
        }
      ]
    }
  ]
}
```

#### Resposta esperada
```bash
{
  "success": {
    "restaurants": [
      {
        "name": "Poppo's Cafe",
        "menus": [
          {
            "name": "lunch",
            "menu_items": [
              {
                "name": "Burger",
                "price": "9.0"
              },
              {
                "name": "Small Salad",
                "price": "5.0"
              }
            ]
          },
        ]
      }
    ]
  },
  "failed": []
}
```

#### Em caso de erro
```bash
{
  "success": {
    "restaurants": []
  },
  "failed": [
    {
      "name": null,
      "error": "Invalid parameters",
      "errors": [
        "Restaurant name is missing"
      ],
      "menus": [
        {
          "name": "lunch",
          "errors": null,
          "items": [
            {
              "name": "Burger",
              "price": 9.0,
              "errors": null
            }
          ]
        }
      ]
    }
  ]
}
```

O fluxo de importação funciona assim:
1. A rota `/api/importation` recebe um JSON contendo restaurantes e seus menus.
2. O validador (`Validators::ImportationRequestParams`) verifica se os dados possuem as chaves corretas e se cada registro está correto.
3. O criador de dados (`Importation::RestaurantsDataCreator`) cria as entidades no banco, tratando erros inesperados.
4. O builder (`Importation::ResponseBuilder`) formata a resposta final, separando os registros importados dos que falharam, retornando uma responsa json.

---
