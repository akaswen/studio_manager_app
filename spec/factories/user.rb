FactoryBot.define do
  factory :user do
    first_name { "Aaron" }
    last_name { "Kaswen" }
    email { "aaron@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }

    after(:build) do |user|
      user.phone_numbers << build(:phone_number) if user.phone_numbers.empty?
      user.addresses << build(:address) if user.addresses.empty?
    end
  end

  factory :teacher, class: User do
    first_name { "Jeff" }
    last_name { "Wienand" }
    email { "jeff@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }
    teacher { true }
    status { nil }

    after(:build) do |user|
      user.phone_numbers << build(:cell_number) if user.phone_numbers.empty?
      user.addresses << build(:home) if user.addresses.empty?
      user.confirm
    end
  end

  factory :student, class: User do
    first_name { Faker::ElderScrolls.first_name }
    last_name { Faker::ElderScrolls.last_name }
    email { Faker::Internet.email }
    password { "Password1" }
    password_confirmation { "Password1" }
    student { true }
    status { nil }

    after(:build) do |user|
      user.phone_numbers << build(:cell_number) if user.phone_numbers.empty?
      user.addresses << build(:home) if user.addresses.empty?
      user.confirm
    end
  end

end
