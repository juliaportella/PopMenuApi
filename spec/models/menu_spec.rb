require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:menus_menu_items).dependent(:destroy) }
    it { is_expected.to have_many(:menu_items).through(:menus_menu_items) }
  end

  describe "validations" do
    context "when menu belongs to a restaurant" do
      let(:restaurant) { create(:restaurant) }
      let(:menu) { build(:menu, restaurant: restaurant) }

      it "is valid" do
        expect(menu).to be_valid
      end
    end

    context "when menu does not have a restaurant" do
      let(:menu) { build(:menu, restaurant: nil) }

      it "is not valid" do
        expect(menu).not_to be_valid
        expect(menu.errors[:restaurant]).to include("must exist")
      end
    end
  end
end
