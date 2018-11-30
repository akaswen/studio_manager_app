module LessonsSpecHelper
  def make_recurring(lesson, confirmed=true)
    3.times do |n|
      new_lesson = Lesson.new(start_time: lesson.start_time + (1 + n).weeks, end_time: lesson.end_time + (1 + n).weeks, location: lesson.location, student_id: lesson.student.id, teacher_id: lesson.student.id, kind: lesson.kind)
      new_lesson.confirmed = true if confirmed
      new_lesson.repeat = true if n == 2
      new_lesson.save!
    end
  end
end
