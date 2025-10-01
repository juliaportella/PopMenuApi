require 'rails_helper'

RSpec.describe Importation::RestaurantsDataCreator, type: :service do
  describe '#perform' do
    context 'when all params are valid' do
      let(:valid_params) do
        {
          restaurants: [
            {
              name: "Poppo's Cafe",
              menus: [
                {
                  name: "lunch",
                  menu_items: [
                    { name: "Burger", price: 9.0 },
                    { name: "Salad", price: 5.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      subject { described_class.new(valid_params) }

      it 'creates restaurants, menus, menu_items and returns imported restaurants' do
        expect { subject.perform }.to change { Restaurant.count }.by(1)
                                  .and change { Menu.count }.by(1)
                                  .and change { MenuItem.count }.by(2)
                                  .and change { MenusMenuItem.count }.by(2)

        result = subject.perform

        expect(result[:imported].map(&:name)).to include("Poppo's Cafe")
        expect(result[:failed]).to be_empty
      end
    end

    context 'when an unexpected error occurs' do
      let(:valid_params) do
        {
          restaurants: [
            {
              name: "Error Cafe",
              menus: [
                { name: "lunch", menu_items: [ { name: "Burger", price: 9.0 } ] }
              ]
            }
          ]
        }
      end

      subject { described_class.new(valid_params) }

      it 'returns failed with the unexpected error message' do
        allow(Restaurant).to receive(:find_or_create_by!).and_raise(StandardError, "some error")

        result = subject.perform

        expect(result[:imported]).to be_empty
        expect(result[:failed].size).to eq(1)
        expect(result[:failed].first[:restaurant]).to eq("Error Cafe")
        expect(result[:failed].first[:error]).to include("Unexpected error: some error")
      end
    end
  end
end
