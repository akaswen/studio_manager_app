FactoryBot.define do
  factory :time_slot do
    day { 1 }   
    time { "01:00" }
    association :schedule, factory: :schedule
  end
end
