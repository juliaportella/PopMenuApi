module Api
  class ImportationController < ApplicationController
    def import
      return render json: { error: "No data received" }, status: :bad_request if params[:restaurants].blank?

      result = Importation::RestaurantData.new(importation_params).perform

      return render json: result, status: :unprocessable_entity if result[:success].empty?

      render json: result, status: :ok
    rescue StandardError => e
      render json: e.message, status: :internal_server_error
    end

    private

    def importation_params
      params.permit(
        restaurants: [
          :name,
          menus: [
            :name,
            menu_items: [ :name, :price ],
            dishes: [ :name, :price ]
          ]
        ]
      ).to_h.deep_symbolize_keys
    end
  end
end
