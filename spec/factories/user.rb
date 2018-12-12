FactoryBot.define do
  factory :user do
    first_name { "Aaron" }
    last_name { "Kaswen" }
    email { "aaron@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }

    after(:build) do |user|
      user.phone_number = build(:phone_number) if user.phone_number.nil?
      user.address = build(:address) if user.address.nil?
    end
  end

  factory :teacher, class: User do
    first_name { "Teacher" }
    last_name { "McTeacherton" }
    email { "jeff@example.com" }
    password { "Password1" }
    password_confirmation { "Password1" }
    teacher { true }
    status { nil }

    after(:build) do |user|
      user.phone_number = build(:phone_number) if user.phone_number.nil?
      user.address = build(:home) if user.address.nil?
      user.confirm
    end
  end

  factory :student, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "Password1" }
    password_confirmation { "Password1" }
    student { true }
    status { nil }
    rate_per_hour { 45 }

    after(:build) do |user|
      user.phone_number = build(:phone_number) if user.phone_number.nil?
      user.address = build(:home) if user.address.nil?
      user.confirm
    end
  end

  factory :student2, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "Password1" }
    password_confirmation { "Password1" }
    student { true }
    status { nil }
    rate_per_hour { 45 }

    after(:build) do |user|
      user.phone_number = build(:phone_number) if user.phone_number.nil?
      user.address = build(:home) if user.address.nil?
      user.confirm
    end
  end

end
