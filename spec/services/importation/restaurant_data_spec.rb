require 'rails_helper'

RSpec.describe Importation::RestaurantData, type: :service do
  let(:initial_params) do
    {
      restaurants: [
        { name: "Poppo's Cafe" },
        { name: "Casa del Poppo" }
      ]
    }
  end

  let(:valid_params) do
    {
      restaurants: [
        {
          name: "Poppo's Cafe",
          menus: [
            { name: "lunch", menu_items: [ { name: "Burger", price: 9.0 } ] }
          ]
        }
      ]
    }
  end

  let(:invalid_params) do
    {
      restaurants: [
        { name: "Casa del Poppo", menus: [ { name: "", menu_items: [] } ] }
      ]
    }
  end

  let(:validated_params) { { valid_params: valid_params, invalid_params: invalid_params } }
  let(:created_data) { { restaurants: [ { name: "Poppo's Cafe", id: 1 } ] } }
  let(:final_response) { { success: created_data[:restaurants], failed: invalid_params[:restaurants] } }

  let(:validator_instance) { instance_double(Validators::ImportationRequestParams, perform: validated_params) }
  let(:creator_instance)   { instance_double(Importation::RestaurantsDataCreator, perform: created_data) }
  let(:response_builder_instance) { instance_double(Importation::ResponseBuilder, perform: final_response) }

  subject { described_class.new(initial_params) }

  before do
    allow(Validators::ImportationRequestParams).to receive(:new).with(initial_params).and_return(validator_instance)
    allow(Importation::RestaurantsDataCreator).to receive(:new).with(valid_params).and_return(creator_instance)
    allow(Importation::ResponseBuilder).to receive(:new).with(created_data, invalid_params).and_return(response_builder_instance)
  end

  describe '#perform' do
    it 'validates the input parameters' do
      subject.perform

      expect(Validators::ImportationRequestParams).to have_received(:new).with(initial_params)
      expect(validator_instance).to have_received(:perform).once
    end

    it 'creates the restaurant data for valid params' do
      subject.perform

      expect(Importation::RestaurantsDataCreator).to have_received(:new).with(valid_params)
      expect(creator_instance).to have_received(:perform).once
    end

    it 'builds the final response including failed data' do
      response = subject.perform

      expect(Importation::ResponseBuilder).to have_received(:new).with(created_data, invalid_params)
      expect(response_builder_instance).to have_received(:perform).once
      expect(response).to eq(final_response)
    end
  end
end
