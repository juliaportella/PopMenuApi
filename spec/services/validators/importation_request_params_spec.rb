require 'rails_helper'

RSpec.describe Validators::ImportationRequestParams, type: :service do
  describe '#perform' do
    context 'with valid restaurant data' do
      let(:params) do
        {
          restaurants: [
            {
              name: "Poppo's Cafe",
              menus: [
                { name: "lunch", menu_items: [{ name: "Burger", price: 9.0 }] }
              ]
            }
          ]
        }
      end

      it 'returns the restaurant as valid and no invalid restaurants' do
        result = described_class.new(params).perform

        expect(result[:valid_params][:restaurants].size).to eq(1)
        expect(result[:invalid_params][:restaurants]).to be_empty
      end
    end

    context 'with invalid restaurant keys' do
      let(:params) do
        {
          restaurants: [
            { name: "Restaurant", menus: [], foo: "invalid key" }
          ]
        }
      end

      it 'returns the restaurant as invalid due to invalid keys' do
        result = described_class.new(params).perform
        invalid = result[:invalid_params][:restaurants].first

        expect(result[:valid_params][:restaurants]).to be_empty
        expect(invalid[:name]).to eq("Restaurant")
        expect(invalid).to have_key(:errors)
        expect(invalid[:errors]).to include("Restaurant has invalid keys")
      end
    end

    context 'with mixed valid and invalid restaurants' do
      let(:params) do
        {
          restaurants: [
            { name: "Poppo's Cafe", menus: [{ name: "lunch", menu_items: [{ name: "Burger", price: 9.0 }] }] },
            { name: "", menus: [{ name: "", menu_items: [] }] }
          ]
        }
      end

      it 'separates valid and invalid restaurants correctly' do
        result = described_class.new(params).perform

        expect(result[:valid_params][:restaurants].size).to eq(1)
        expect(result[:valid_params][:restaurants].first[:name]).to eq("Poppo's Cafe")

        invalid_restaurant = result[:invalid_params][:restaurants].first

        expect(result[:invalid_params][:restaurants].size).to eq(1)
        expect(invalid_restaurant[:name]).to eq("")

        expect(invalid_restaurant).to have_key(:errors)
        expect(invalid_restaurant[:errors]).to include("Restaurant name is missing")

        expect(invalid_restaurant[:menus].first).not_to have_key(:errors)
      end
    end
  end
end
