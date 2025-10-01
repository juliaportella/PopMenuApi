RSpec.describe MenuItem, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:menus_menu_items).dependent(:destroy) }
    it { is_expected.to have_many(:menus).through(:menus_menu_items) }
  end

  describe "validations" do
    context "when menu item name is unique" do
      let(:menu_item) { build(:menu_item, name: "Unique Name") }

      it "is valid" do
        expect(menu_item).to be_valid
      end
    end

    context "when menu item already exists" do
      let!(:existing_menu_item) { create(:menu_item, name: "Unique Name") }
      let(:new_menu_item) { build(:menu_item, name: "Unique Name") }

      it "is not valid" do
        expect(new_menu_item).not_to be_valid
        expect(new_menu_item.errors[:name]).to include("has already been taken")
      end
    end
  end
end
