require 'rails_helper'

RSpec.describe Api::ImportationController, type: :controller do
  describe "POST #import" do
    context "when no data is sent" do
      it "returns bad_request status with error message" do
        post :import, params: {}

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "No data received" })
      end
    end

    context "when valid data is sent" do
      let(:valid_params) do
        {
          restaurants: [
            {
              name: "Test Restaurant",
              menus: [
                {
                  name: "Lunch Menu",
                  menu_items: [
                    { name: "Burger", price: 10.5 }
                  ],
                  dishes: [
                    { name: "Fries", price: 4.5 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it "calls Importation::RestaurantData and returns ok" do
        fake_result = { success: [ "Test Restaurant" ], failed: [] }

        expect_any_instance_of(Importation::RestaurantData).to receive(:perform).and_return(fake_result)

        post :import, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(JSON.parse(fake_result.to_json))
      end
    end

    context "when import fails" do
      let(:invalid_params) do
        { restaurants: [ { name: "" } ] }
      end

      it "returns unprocessable_entity" do
        fake_result = { success: [], failed: [ "Invalid data" ] }

        expect_any_instance_of(Importation::RestaurantData).to receive(:perform).and_return(fake_result)

        post :import, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(JSON.parse(fake_result.to_json))
      end
    end

    context "when an exception is raised" do
      it "returns internal_server_error with message" do
        allow_any_instance_of(Importation::RestaurantData)
          .to receive(:perform)
          .and_raise(StandardError, "Unexpected error")

        post :import, params: { restaurants: [ { name: "Something" } ] }

        expect(response).to have_http_status(:internal_server_error)
        expect(response.body).to eq("Unexpected error")
      end
    end
  end
end
