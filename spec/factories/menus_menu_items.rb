FactoryBot.define do
    factory :menus_menu_item do
      association :menu
      association :menu_item
      price { 50.0 }
    end
  end