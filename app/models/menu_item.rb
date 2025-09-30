class MenuItem < ApplicationRecord
  has_many :menus_menu_items, dependent: :destroy
  has_many :menus, through: :menus_menu_items
  validates :name, uniqueness: true
end
