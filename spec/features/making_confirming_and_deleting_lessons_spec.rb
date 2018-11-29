require 'rails_helper'

RSpec.feature "MakingLessons", type: :feature do
  before(:each) do
    @schedule = create(:schedule)
    @teacher = @schedule.user
    @student = create(:student)
    @student2 = create(:student2)
    @time_slot = @schedule.time_slots.first
    ActionController::Base.allow_forgery_protection = true
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
    ActionMailer::Base.deliveries.clear
    Lesson.destroy_all
  end

  subject { 
    sign_in(@student)
    click_link('Lessons')
    find('i.fa-caret-right').click
    within('.sunday') do
      click_button('12:00')
    end
  }

  it('allows a student to make a new single lesson', js:true) do
    subject
    within('.inner-menu') do
      expect(page).to have_content('Lesson Request')
      expect(page).to have_content('12:00')
      select('60 minutes', from: 'duration')
      choose('occurence', option: 'single')
      expect{ click_button('Okay') }.to change{ Lesson.count }.by(1)
    end
    sleep 1
    within('.sunday') do
      click_button('12:00')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
    within('.sunday') do
      click_button('12:15')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
    within('.sunday') do
      click_button('12:30')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
    within('.sunday') do
      click_button('12:45')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
    within('.sunday') do
      click_button('11:45')
    end
    within('.inner-menu') do
      expect(page).to have_content('must have at least 30 minutes of available time')
      click_button('Okay')
    end
  end

  it("allows a student to make new weekly lessons that are visible over the next four weeks", js: true) do
    subject
    within('.inner-menu') do
      expect(page).to have_content('Lesson Request')
      expect(page).to have_content('12:00')
      select('60 minutes', from: 'duration')
      expect{ click_button('Okay') }.to change{ Lesson.count }.by(4)
    end
    sleep 1
    find('i.fa-caret-right').click
     within('.sunday') do
      click_button('12:00')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
    find('i.fa-caret-right').click
     within('.sunday') do
      click_button('12:00')
    end
    within('.inner-menu') do
      expect(page).to have_content('this slot is not available')
      click_button('Okay')
    end
  end

  describe('confirming and deleting') do
    before(:each) do
      ActionController::Base.allow_forgery_protection = false
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.save!
    end

    it("allows a teacher to confirm a single lesson") do
      sign_in(@teacher)
      within('#teacher-sidebar') do
        click_button('New Lesson Requests')
        click_link('Confirm')
      end
      @lesson.reload
      expect(@lesson.confirmed).to eq(true)
    end

    it("allows a teacher to confirm weekly lessons") do
      make_recurring(@lesson, false)
      sign_in(@teacher)
      within('#teacher-sidebar') do
        click_button('New Lesson Requests')
        click_link('Confirm')
      end
      Lesson.all.each do |lesson|
        expect(lesson.confirmed).to eq(true)
      end
    end

    it("allows a teacher to delete a new single lesson") do
      sign_in(@teacher)
      within('#teacher-sidebar') do
        click_button('New Lesson Requests')
        expect{ click_link('Delete') }.to change{ Lesson.count }.by(-1)
      end
    end

    it("allows a teacher to delete new weekly lessons") do
      make_recurring(@lesson, false)
      sign_in(@teacher)
      within('#teacher-sidebar') do
        click_button('New Lesson Requests')
        click_link('Delete')
      end
      expect(Lesson.count).to eq(0)
    end
  end

  it("allows a teacher to make a lesson for any student in their studio", js: true) do
    sign_in(@teacher)
    click_link('Lessons')
    find('i.fa-caret-right').click
    within('.sunday') do
      click_button('12:00')
    end
    within('.inner-menu') do
      expect(page).to have_content('Choose Student')
      expect(page).to have_content('12:00')
      select(@student.full_name.downcase, from: 'student')
      select('60 minutes', from: 'duration')
      choose('occurence', option: 'weekly')
      expect{ click_button('Okay') }.to change{ Lesson.count }.by(4)
    end
  end
end
