module Importation
  class RestaurantsDataCreator
    def initialize(valid_params)
      @valid_params = valid_params
    end

    def perform
      results = {
        imported: [],
        failed: []
      }

      @valid_params[:restaurants].each do |restaurant_data|
        begin
          ActiveRecord::Base.transaction do
            restaurant = Restaurant.find_or_create_by!(name: restaurant_data[:name])

            restaurant_data[:menus].each do |menu_data|
              menu = Menu.find_or_create_by!(name: menu_data[:name], restaurant_id: restaurant.id)

              items = menu_data[:menu_items] || menu_data[:dishes]

              items.each do |item_data|
                item = MenuItem.find_or_create_by!(name: item_data[:name])

                MenusMenuItem.find_or_create_by!(
                  menu_id: menu.id,
                  menu_item_id: item.id,
                  price: item_data[:price]
                )
              end
            end

            results[:imported] << restaurant
          end
        rescue ActiveRecord::RecordInvalid => e
          results[:failed] << { restaurant: restaurant_data[:name], error: "Failed to import: #{e.message}" }
        rescue StandardError => e
          results[:failed] << { restaurant: restaurant_data[:name], error: "Unexpected error: #{e.message}" }
        end
      end

      results
    end
  end
end
