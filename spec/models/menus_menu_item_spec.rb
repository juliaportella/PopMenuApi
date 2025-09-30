require 'rails_helper'

RSpec.describe MenusMenuItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:menu) }
    it { is_expected.to belong_to(:menu_item) }
  end

  describe "validations" do
    context "when price is present" do
      let(:menu) { create(:menu) }
      let(:menu_item) { create(:menu_item) }
      let(:menus_menu_item) { build(:menus_menu_item, menu: menu, menu_item: menu_item, price: 10.0) }

      it "is valid" do
        expect(menus_menu_item).to be_valid
      end
    end

    context "when price is missing" do
      let(:menu) { create(:menu) }
      let(:menu_item) { create(:menu_item) }
      let(:menus_menu_item) { build(:menus_menu_item, menu: menu, menu_item: menu_item, price: nil) }

      it "is not valid" do
        expect(menus_menu_item).not_to be_valid
        expect(menus_menu_item.errors[:price]).to include("can't be blank")
      end
    end
  end
end
