FactoryBot.define do
  factory :payment do
    amount { 400.0 }
    association :user, factory: :student
  end
end
