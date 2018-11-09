FactoryBot.define do
  factory :lesson do
    start_time { Time.now + 5.days }
    end_time { Time.now + 5.days + 1.hour }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
  end
end
