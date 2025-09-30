class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menus_menu_items, dependent: :destroy
  has_many :menu_items, through: :menus_menu_items
end