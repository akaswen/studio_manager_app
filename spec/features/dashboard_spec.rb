require 'rails_helper'

RSpec.feature "Dashboards", type: :feature do
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
 
  describe('lessons timeline') do
    it('gets all lessons for the week for a teacher') do
      sign_in(@teacher)
      within('#teacher-lessons') do
        [@lesson, @lesson2].each do |lesson|
          expect(page).to have_link(href: lesson_path(lesson))
        end
      end
    end

    it('gets all lessons for a student') do
      make_recurring(@lesson)
      Lesson.all.each { |l| l.update_attribute(:confirmed, true) }
      sign_in(@student)
      Lesson.where(student_id: @student.id).each do |lesson|
        within('#student-lessons') do
          expect(page).to have_link(href: lesson_path(lesson))
       end
     end
    end

    it('gets only confirmed lessons for a teacher') do
      @lesson2.update_attribute(:confirmed, false)
      sign_in(@teacher)
      within('#teacher-lessons') do
        expect(page).to have_link(href: lesson_path(@lesson))
        expect(page).to_not have_link(href: lesson_path(@lesson2))
      end
    end

    it('gets only confirmed lessons for a student') do
      @lesson.update_attribute(:confirmed, false)
      sign_in(@student)
      within('#student-lessons') do
        expect(page).to_not have_link(href: lesson_path(@lesson))
      end
    end

    it('only gets the lessons of a student for that student') do
      sign_in(@student2)
       within('#student-lessons') do
        expect(page).to_not have_link(href: lesson_path(@lesson))
        expect(page).to have_link(href: lesson_path(@lesson2))
      end
    end
  end

  describe('unpaid taught lessons') do
    before(:each) do
      @lesson.update_attribute(:start_time, @lesson.start_time - 2.weeks)
      @lesson.update_attribute(:end_time, @lesson.end_time - 2.weeks)
      sign_in(@teacher)
    end

    it('displays a lesson that is past and unpaid') do
      within('#teacher-sidebar') do
        expect(page).to have_link(@lesson.student.full_name)
        expect(page).to have_link(href: lesson_path(@lesson))
      end
    end

    it("once lesson is paid for it no longer display's") do
      @lesson.update_attribute(:paid, true)
      visit dashboard_path
      within('#teacher-sidebar') do
        expect(page).to_not have_link(@lesson.student.full_name)
        expect(page).to_not have_link(href: lesson_path(@lesson))
      end
   end

    it("teacher can delete that lesson") do
      within('#teacher-sidebar') do
        click_button("Past Unpaid Lessons")
        expect{
          click_link("Delete")
        }.to change{ Lesson.count }.by(-1)
      end
    end
  end
end
