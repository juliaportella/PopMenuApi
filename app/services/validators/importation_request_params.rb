module Validators
  class ImportationRequestParams
    VALID_RESTAURANT_KEYS = %i[name menus].freeze
    VALID_MENU_KEYS = %i[name menu_items dishes].freeze

    def initialize(params)
      @params = params || {}
      @restaurants = @params[:restaurants] || []
    end

    def perform
      valid_restaurants = []
      invalid_restaurants = []

      @restaurants.each do |restaurant|
        errors = validate_restaurant(restaurant)

        if errors.any?
          invalid_restaurants << restaurant.merge(errors: errors)
        else
          menus_validation = validate_menus(restaurant[:menus])

          if menus_validation[:invalid_menus].any?
            invalid_restaurants << restaurant.merge(menus: menus_validation[:invalid_menus])
          else
            valid_restaurants << restaurant.merge(menus: menus_validation[:valid_menus])
          end
        end
      end

      { valid_params: { restaurants: valid_restaurants }, invalid_params: { restaurants: invalid_restaurants } }
    end

    private

    def validate_restaurant(restaurant)
      errors = []
      errors << "Restaurant must be a valid object" unless restaurant.is_a?(Hash)
      errors << "Restaurant has invalid keys" unless has_only_valid_keys?(restaurant, VALID_RESTAURANT_KEYS)
      errors << "Restaurant name is missing" unless restaurant[:name].present?
      errors << "Restaurant must have menus array" unless restaurant[:menus].is_a?(Array)
      errors
    end

    def validate_menus(menus)
      valid_menus = []
      invalid_menus = []

      menus.each do |menu|
        errors = validate_menu(menu)

        if errors.any?
          invalid_menus << menu.merge(errors: errors)
        else
          items_key = menu.key?(:menu_items) ? :menu_items : :dishes
          items_validation = validate_items(menu[items_key] || [])

          if items_validation[:invalid_items].any?
            invalid_menus << menu.merge(items_key => items_validation[:invalid_items])
          else
            valid_menus << menu.merge(items_key => items_validation[:valid_items])
          end
        end
      end
      { valid_menus: valid_menus, invalid_menus: invalid_menus }
    end

    def validate_menu(menu)
      errors = []
      errors << "Menu must be a valid object" unless menu.is_a?(Hash)
      errors << "Menu has invalid keys" unless has_only_valid_keys?(menu, VALID_MENU_KEYS)
      errors << "Menu name is missing" unless menu[:name].present?
      errors << "Menu must have menu_items or dishes array" unless menu[:menu_items].is_a?(Array) || menu[:dishes].is_a?(Array)
      errors
    end

    def validate_items(items)
      valid_items = []
      invalid_items = []

      items.each do |item|
        errors = validate_item(item)

        if errors.any?
          invalid_items << item.merge(errors: errors)
        else
          valid_items << item
        end
      end
      { valid_items: valid_items, invalid_items: invalid_items }
    end

    def validate_item(item)
      errors = []
      errors << "Item must be a valid object" unless item.is_a?(Hash)
      errors << "Item name is missing" unless item[:name].present?
      errors << "Item price is missing" unless item[:price].present?
      errors << "Item price must be a positive number" unless item[:price].is_a?(Numeric) && item[:price] >= 0
      errors
    end

    def has_only_valid_keys?(hash, valid_keys)
      (hash.keys.to_set - valid_keys.to_set).empty?
    end
  end
end
