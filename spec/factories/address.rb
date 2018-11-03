FactoryBot.define do
  factory :address do
    street_address { "55 hill street" }
    city { "Springfield" }
    state { "NJ" }
    zip_code { "55555" }
  end

  factory :home, class: Address do
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip[0..4] }
  end
end

