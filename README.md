
# PopMenuApi

An application to manage restaurants, menus, and menu items, with support for data import via API.

---

### 🔹 Project Description
This application allows you to:
- Create and list restaurants, menus, and menu items.
- Validate restaurant, menu, and item data before import.
- Import data via API, returning success and failure reports.


### 🔹 Technologies Used

- Ruby 3.x
- Ruby on Rails 7.x
- PostgreSQL
- RSpec / FactoryBot for testing

---

### 🔹 Project Setup

Clone the repository:

```bash
git clone git@github.com:juliaportella/PopMenuApi.git
cd PopMenuApi
````

Bring up the application:

```bash
docker compose up
```

-----

### 📌 Available Routes

#### Restaurants

  - GET `/restaurants` → Lists all restaurants
  - GET `/restaurants/:id` → Shows a specific restaurant

#### Menus

  - GET `/menus` → Lists all menus
  - GET `/menus/:id` → Shows a specific menu

#### Menu Items

  - GET `/menu_items` → Lists all menu items
  - GET `/menu_items/:id` → Shows a specific menu item


#### Menu and Menu Items Relations

- GET `/menus_menu_items` → Lists all relations between menu and menu_items
- GET `/menus_menu_items/:id` → Shows a specific relation

-----

### 📥 Import Route

Allows importing restaurants, menus, and items in bulk via JSON.

#### Endpoint

POST `/api/importation`

#### Payload Example

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

#### Expected Success Response

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

#### In Case of Error Response

```bash
{
  "success": {
    "restaurants": []
  },
  "failed": {
    "restaurants": [
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
}
```

#### The Import Flow Works As Follows:

1.  The `/api/importation` route receives a JSON containing restaurants and their menus.
2.  The validator (`Validators::ImportationRequestParams`) checks if the data has the correct keys and if each record is valid.
3.  The data creator (`Importation::RestaurantsDataCreator`) creates the entities in the database, handling unexpected errors.
4.  The builder (`Importation::ResponseBuilder`) formats the final response, separating imported records from failed ones, returning a JSON response.

-----

#### Technical Decisions

To meet the requirements as closely as possible, I made some decisions in this phase that can be easily readjusted in the future due to the project's flexibility.
I would like to emphasize that, in a production environment, the adopted approach would be different. Considering scalability and maintenance, it would not be appropriate to accept multiple key variations (like `dishes` and `menu_items`) and delegate the responsibility to the backend to handle and normalize all of them. This would increase code complexity, hinder application evolution, and potentially generate data inconsistencies.

The most recommended practice would be to clearly define which parameters the API accepts for registering restaurants, menus, and menu items, ensuring predictability and consistency.

However, considering the context of the technical test, the decision to also accept the `dishes` key aims to make the most of the provided data, ensuring that the largest possible number of items is registered in the application.
