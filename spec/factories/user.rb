FactoryBot.define do
  factory :user do
    first_name { "Aaron" }
    last_name { "Kaswen" }
    email { "aaron@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }

    after(:build) do |user|
      if user.phone_numbers.empty?
        phone_number = build(:phone_number)
        user.phone_numbers << phone_number
      end
      if user.addresses.empty?
        address = build(:address)
        user.addresses << address
      end
    end
  end
end
