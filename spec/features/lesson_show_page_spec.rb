require 'rails_helper'

RSpec.feature "LessonShowPages", type: :feature do
  before(:each) do
    @lesson = create(:lesson)
    @student = @lesson.student
    @teacher = @lesson.teacher
    sign_in(@teacher)
  end

  it('deletes one lesson') do
    visit lesson_path(@lesson)
    expect{
      click_link('Cancel This Lesson')
    }.to change{ Lesson.count }.by(-1)
  end

  it('deletes all recurring lessons') do
    make_recurring(@lesson)
    visit lesson_path(@lesson)
    expect{
      click_link('Cancel Weekly Lessons') 
    }.to change{ Lesson.count }.by(-4)
  end

  it('confirms one lesson') do
    visit lesson_path(@lesson)
    click_link('Confirm This Lesson')
    expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
    expect(page).to_not have_link('Confirm This Lesson')
    expect(page).to have_link('Cancel This Lesson')
  end

  it('confirms recurring lessons') do
    make_recurring(@lesson)
    visit lesson_path(@lesson)
    click_link('Confirm Recurring Lessons')
    expect(page).to_not have_link('Confirm Recurring Lessons')
    expect(page).to have_link('Cancel This Lesson')
    Lesson.all.each do |l|
      expect(l).to be_confirmed
    end
  end

  it("doesn't allow a student to cancel a lesson within 24 hours of start time") do
    @lesson.update_attribute(:start_time, Time.now.utc + 23.hours + 59.minutes)
    sign_out(@teacher)
    sign_in(@student)
    visit lesson_path(@lesson)
    expect(page).to_not have_link('Cancel This Lesson')
  end

  it("does allow a teacher to cancel a lesson within 24 hours of start time") do
    @lesson.update_attribute(:start_time, Time.now.utc + 23.hours + 59.minutes)
    visit lesson_path(@lesson)
    expect(page).to have_link('Cancel This Lesson')
  end

  it("doesn't allow a teacher to cancel a lesson that is passed and paid") do
    @lesson.update_attribute(:paid, true)
    @lesson.update_attribute(:start_time, Time.now - 1.hour)
    @lesson.update_attribute(:end_time, Time.now)
    visit lesson_path(@lesson)
    expect(page).to_not have_link('Cancel This Lesson')
  end
end
