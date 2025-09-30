class CreateMenusMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menus_menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
