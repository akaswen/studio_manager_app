FactoryBot.define do
  factory :lesson do
    start_time { Time.now.beginning_of_day + 5.days + 10.hours }
    end_time { Time.now.beginning_of_day + 5.days + 11.hours }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
  end
end
