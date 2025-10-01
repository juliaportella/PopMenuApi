RSpec.describe Restaurant, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:menus).dependent(:destroy) }
  end

  describe "validations" do
    context "when restaurant name is present and unique" do
      let(:restaurant) { build(:restaurant) }

      it "is valid" do
        expect(restaurant).to be_valid
      end
    end

    context "when restaurant name is missing" do
      let(:restaurant) { build(:restaurant, name: nil) }

      it "is not valid" do
        expect(restaurant).not_to be_valid
        expect(restaurant.errors[:name]).to include("can't be blank")
      end
    end

    context "when restaurant name already exists" do
      let!(:existing_restaurant) { create(:restaurant, name: "Paris Restaurant") }
      let(:new_restaurant) { build(:restaurant, name: "Paris Restaurant") }

      it "is not valid" do
        expect(new_restaurant).not_to be_valid
        expect(new_restaurant.errors[:name]).to include("has already been taken")
      end
    end
  end
end
