class MenusMenuItemsController < ApplicationController
  before_action :set_menus_menu_item, only: %i[ show update destroy ]

  # GET /menus_menu_items
  def index
    @menus_menu_items = MenusMenuItem.all

    render json: @menus_menu_items
  end

  # GET /menus_menu_items/1
  def show
    render json: @menus_menu_item
  end

  # POST /menus_menu_items
  def create
    @menus_menu_item = MenusMenuItem.new(menus_menu_item_params)

    if @menus_menu_item.save
      render json: @menus_menu_item, status: :created, location: @menus_menu_item
    else
      render json: @menus_menu_item.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /menus_menu_items/1
  def update
    if @menus_menu_item.update(menus_menu_item_params)
      render json: @menus_menu_item
    else
      render json: @menus_menu_item.errors, status: :unprocessable_content
    end
  end

  # DELETE /menus_menu_items/1
  def destroy
    @menus_menu_item.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menus_menu_item
      @menus_menu_item = MenusMenuItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def menus_menu_item_params
      params.expect(menus_menu_item: [ :menu_id, :menu_item_id, :price ])
    end
end
