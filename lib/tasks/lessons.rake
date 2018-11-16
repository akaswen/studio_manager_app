task new_week: :environment do
  Lesson.add_new_week_of_lessons
end
