FactoryBot.define do
  factory :schedule do
    association :user, factory: :teacher
  end
end
