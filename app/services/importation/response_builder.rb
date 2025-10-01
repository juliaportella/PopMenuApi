module Importation
  class ResponseBuilder
    def initialize(imported_data, invalid_data)
      @imported_data = imported_data
      @invalid_data = invalid_data
    end

    def perform
      {
        success: format_success,
        failed: format_failed
      }
    end

    private

    def format_success
      {
        restaurants:
          @imported_data[:imported].map do |restaurant|
            {
              name: restaurant.name,
              menus: restaurant.menus.map do |menu|
                {
                  name: menu.name,
                  menu_items: menu.menu_items.map do |item|
                    {
                      name: item.name,
                      price: item.menus_menu_items.find_by(menu_id: menu.id).price
                    }
                  end
                }
              end
            }
          end
      }
    end

    def format_failed
      failed_imports = @imported_data[:failed].map do |f|
        { restaurant: f[:restaurant], error: f[:error] }
      end

      failed_invalids = @invalid_data[:restaurants].map do |restaurant|
        {
          name: restaurant[:name],
          error: "Invalid parameters",
          errors: restaurant[:errors],
          menus: (restaurant[:menus] || []).map do |menu|
            {
              name: menu[:name] || "unknown",
              errors: menu[:errors],
              items: ((menu[:menu_items] || menu[:dishes]) || []).map do |item|
                {
                  name: item[:name] || "unknown",
                  price: item[:price],
                  errors: item[:errors]
                }
              end
            }
          end
        }
      end

      {
        restaurants: failed_imports + failed_invalids
      }
    end
  end
end
