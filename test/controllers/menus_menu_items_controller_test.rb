require "test_helper"

class MenusMenuItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menus_menu_item = menus_menu_items(:one)
  end

  test "should get index" do
    get menus_menu_items_url, as: :json
    assert_response :success
  end

  test "should create menus_menu_item" do
    assert_difference("MenusMenuItem.count") do
      post menus_menu_items_url, params: { menus_menu_item: { menu_id: @menus_menu_item.menu_id, menu_item_id: @menus_menu_item.menu_item_id, price: @menus_menu_item.price } }, as: :json
    end

    assert_response :created
  end

  test "should show menus_menu_item" do
    get menus_menu_item_url(@menus_menu_item), as: :json
    assert_response :success
  end

  test "should update menus_menu_item" do
    patch menus_menu_item_url(@menus_menu_item), params: { menus_menu_item: { menu_id: @menus_menu_item.menu_id, menu_item_id: @menus_menu_item.menu_item_id, price: @menus_menu_item.price } }, as: :json
    assert_response :success
  end

  test "should destroy menus_menu_item" do
    assert_difference("MenusMenuItem.count", -1) do
      delete menus_menu_item_url(@menus_menu_item), as: :json
    end

    assert_response :no_content
  end
end
