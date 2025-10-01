require "rails_helper"

RSpec.describe Importation::ResponseBuilder, type: :service do
  describe "#perform" do
    let!(:restaurant) { create(:restaurant, name: "Poppo's Cafe") }
    let!(:menu) { create(:menu, name: "Lunch Menu", restaurant: restaurant) }
    let!(:menu_item1) { create(:menu_item, name: "Burger") }
    let!(:menu_item2) { create(:menu_item, name: "Fries") }

    before do
      create(:menus_menu_item, menu: menu, menu_item: menu_item1, price: 9.0)
      create(:menus_menu_item, menu: menu, menu_item: menu_item2, price: 4.5)
    end

    let(:imported_data) do
      {
        imported: [ restaurant ],
        failed: [
          { restaurant: "Failed Restaurant", error: "Unexpected error: foo" }
        ]
      }
    end

    let(:invalid_data) do
      {
        restaurants: [
          {
            name: "Validation Failed Restaurant",
            errors: [ "Restaurant has invalid keys" ],
            menus: [
              {
                name: "Bad Menu",
                errors: [ "Menu name is missing" ],
                menu_items: [
                  { name: "Bad Item", price: 0, errors: [ "Item price is zero" ] }
                ]
              }
            ]
          }
        ]
      }
    end

    subject { described_class.new(imported_data, invalid_data) }

    it "formats success correctly" do
      result = subject.perform

      expect(result[:success]).to eq([
        {
          name: "Poppo's Cafe",
          menus: [
            {
              name: "Lunch Menu",
              menu_items: [
                { name: "Burger", price: 9.0 },
                { name: "Fries", price: 4.5 }
              ]
            }
          ]
        }
      ])
    end

    it "formats failed correctly" do
      result = subject.perform

      expect(result[:failed].size).to eq(2)
      expect(result[:failed].first).to eq(
        { restaurant: "Failed Restaurant", error: "Unexpected error: foo" }
      )
      expect(result[:failed].second[:name]).to eq("Validation Failed Restaurant")
    end

    context "when no data is imported or invalid" do
      let(:imported_data) { { imported: [], failed: [] } }
      let(:invalid_data) { { restaurants: [] } }

      it "returns empty arrays for success and failed" do
        result = subject.perform
        expect(result[:success]).to be_empty
        expect(result[:failed]).to be_empty
      end
    end
  end
end
