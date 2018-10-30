FactoryBot.define do
  factory :address do
    street_address { "55 hill street" }
    city { "Springfield" }
    state { "NJ" }
    zip_code { "55555" }
    user
  end
end

