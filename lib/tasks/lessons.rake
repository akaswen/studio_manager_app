task new_week: :environment do
  Lesson.add_new_week_of_lessons if Time.now.wday == 0
end
