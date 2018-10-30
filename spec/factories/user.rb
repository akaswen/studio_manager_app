FactoryBot.define do
  factory :user do
    first_name { "Aaron" }
    last_name { "Kaswen" }
    email { "aaron@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }
  end
end
