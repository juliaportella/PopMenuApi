FactoryBot.define do
  factory :menu do
    name { "Valentine's Day" }
    association :restaurant
  end
end
