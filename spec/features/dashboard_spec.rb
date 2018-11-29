require 'rails_helper'

RSpec.feature "Dashboards", type: :feature do
  describe('lessons timeline') do
    before(:each) do
      @lesson = create(:lesson)
      @student = @lesson.student
      @teacher = @lesson.teacher
      @lesson.update_attribute(:confirmed, true)
      @student2 = create(:student2)
      @lesson2 = Lesson.new(attributes_for(:lesson2))
      @lesson2.student = @student2
      @lesson2.teacher = @teacher
      @lesson2.confirmed = true
      @lesson2.save
    end

    it('gets all lessons for the week for a teacher') do
      sign_in(@teacher)
      within('#teacher-lessons') do
        [@lesson, @lesson2].each do |lesson|
          expect(page).to have_link(lesson.start_time.strftime('%A, %B%e, %I:%M %p'))
        end
      end
    end

    it('gets all lessons for a student') do
      make_recurring(@lesson)
      Lesson.all.each { |l| l.update_attribute(:confirmed, true) }
      sign_in(@student)
      Lesson.where(student_id: @student.id).each do |lesson|
        within('#student-lessons') do
          expect(page).to have_link(lesson.start_time.strftime('%e, %I:%M %p'))
       end
     end
    end

    it('gets only confirmed lessons for a teacher') do
      @lesson2.update_attribute(:confirmed, false)
      sign_in(@teacher)
      expect(page).to have_link(@lesson.start_time.strftime('%A, %B%e, %I:%M %p'))
      expect(page).to_not have_link(@lesson2.start_time.strftime('%A, %B%e, %I:%M %p'))
    end

    it('gets only confirmed lessons for a student') do
      @lesson.update_attribute(:confirmed, false)
      sign_in(@student)
      within('#student-lessons') do
        expect(page).to_not have_link(@lesson.start_time.strftime('%A, %B%e, %I:%M %p'))
      end
    end

    it('only gets the lessons of a student for that student') do
      sign_in(@student2)
       within('#student-lessons') do
        expect(page).to_not have_link(@lesson.start_time.strftime('%A, %B%e, %I:%M %p'))
        expect(page).to have_link(@lesson2.start_time.strftime('%A, %B%e, %I:%M %p'))
      end
   end
  end
end
