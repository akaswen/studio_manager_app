FactoryBot.define do
  factory :lesson do
    start_time { Time.now.utc.beginning_of_day + 5.days + 10.hours }
    end_time { Time.now.utc.beginning_of_day + 5.days + 11.hours }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
  end

  factory :lesson2, class: Lesson do
    start_time { Time.now.utc.beginning_of_day + 6.days + 10.hours }
    end_time { Time.now.utc.beginning_of_day + 6.days + 11.hours }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
 end

  factory :lesson3, class: Lesson do
    start_time { Time.now.utc.beginning_of_day + 8.days + 10.hours }
    end_time { Time.now.utc.beginning_of_day + 8.days + 11.hours }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
 end

  factory :lesson4, class: Lesson do
    start_time { Time.now.utc.beginning_of_day + 9.days + 10.hours }
    end_time { Time.now.utc.beginning_of_day + 9.days + 11.hours }
    location { 'teacher' }
    association :teacher, factory: :teacher
    association :student, factory: :student
 end
end
