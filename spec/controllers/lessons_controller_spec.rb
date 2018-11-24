require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  before(:each) do
    @schedule = create(:schedule)
    @teacher = @schedule.user
    @student = create(:student)
    @user = create(:user)
    @user.confirm
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe("GET #new") do
    subject { get :new }

    it('renders a new template for a teacher') do
      sign_in(@teacher)
      subject
      expect(response).to render_template('new')
    end

    it('renders a new template for a student') do
      sign_in(@student)
      subject
      expect(response).to render_template('new')
    end

    it('redirects non-user') do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it('redirects a non-student non-teacher user') do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
    end

    describe('getting lessons') do #these tests may fail late on a saturday evening
      before(:each) do
        4.times do |w|
          (w + 1).times do |h|
            start_time = Time.now + 1.hour + (1 * h).hours + (1 * w).weeks
            lesson = Lesson.new(start_time: start_time, end_time: start_time + 1.hour, location: "teacher")
            lesson.student = @student
            lesson.teacher = @teacher

            lesson.save!
          end
        end
        sign_in(@student)
      end

      it('gets this weeks lessons with no parameters') do
        subject
        expect(assigns(:weeks_lessons).length).to eq(1)
      end

      it('gets next weeks lessons') do
        get :new, params: { week: 2 }
        expect(assigns(:weeks_lessons).length).to eq(2)

      end

      it('gets lessons three weeks away') do
        get :new, params: { week: 3 }
        expect(assigns(:weeks_lessons).length).to eq(3)

      end

      it('gets lessons four weeks away') do
        get :new, params: { week: 4 }
        expect(assigns(:weeks_lessons).length).to eq(4)

      end

      it('does not get lessons more than four weeks away') do
        get :new, params: { week: 5 }
        expect(assigns(:weeks_lessons).length).to eq(1)
      end
    end
  end

  describe("POST #create") do

    subject { 
      time = (DateTime.now + 10.days).strftime("%a %b %e") + " 08:00"
      post :create, params: {
      time: time,
      location: "teacher",
      length: "60",
      occurence: "single"
    } }

    it('creates a new lesson') do
      sign_in(@student)
      expect{ subject }.to change{Lesson.count}.by(1)
      @lesson = Lesson.last
      expect(@lesson.start_time.to_datetime.hour).to eq(8)
      expect(@lesson.start_time.to_datetime.minute).to eq(0)
      expect(@lesson.location).to eq("teacher")
      expect(@lesson.end_time).to eq(@lesson.start_time + 1.hour)
    end

    it('creates 4 lessons for weekly') do
      time = (DateTime.now + 10.days).strftime("%a %b %e") + " 08:00"

      sign_in(@student)
      expect{
        post :create, params: {
          time: time,
          location: "teacher",
          length: "60",
          occurence: "weekly"
        }
      }.to change{Lesson.count}.by(4)
      expect(Lesson.last.repeat).to eq(true)
    end

    it("doesn't allow a non-student to create a lesson") do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
    end

    it("doesn't allow a non-user to create a lesson") do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it('sends an email to the teacher') do
      sign_in(@student)
      expect{ subject }.to change{ ActionMailer::Base.deliveries.length }.by(1)
    end

    it("allows a teacher to create a confirmed lesson") do
      time = (DateTime.now + 10.days).strftime("%a %b %e") + " 08:00"

      sign_in(@teacher)
      expect{
        post :create, params: {
          time: time,
          location: "teacher",
          length: "60",
          occurence: "single",
          id: @student.id
        }
      }.to change{ Lesson.count }.by(1).and change{ ActionMailer::Base.deliveries.length }.by(0)
      expect(Lesson.last).to be_confirmed
    end

    it("doesn't allow a student to create a lesson for someone else") do
      time = (DateTime.now + 10.days).strftime("%a %b %e") + " 08:00"
      @student2 = create(:student2)

      sign_in(@student)
      expect{
        post :create, params: {
          time: time,
          location: "teacher",
          length: "60",
          occurence: "single",
          id: @student2.id
        }
      }.to change{ Lesson.count }.by(0)
    end

    it("doesn't allow the creation of any lessons for recurring if a time slot in the future isn't available") do
      time = (DateTime.now + 10.days).strftime("%a %b %e") + " 08:00"
      @lesson = Lesson.create!(start_time: DateTime.now.utc.beginning_of_day + 31.days + 8.hours, end_time: DateTime.now.utc.beginning_of_day + 31.days + 9.hours, location: "teacher", student_id: @student.id, teacher_id: @teacher.id)
      sign_in(@student)
      expect{
        post :create, params: {
          time: time,
          location: "teacher",
          length: "60",
          occurence: "weekly",
        }
      }.to change{ Lesson.count }.by(0).and raise_error
    end
  end

  describe('POST #update') do
    before(:each) do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.save
    end

    subject { patch :update, params: { id: @lesson.id, occurence: "single" } }

    it("confirms a lesson") do
      sign_in(@teacher)
      expect{ subject }.to change{ ActionMailer::Base.deliveries.length }.by(1)
      expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
    end

    it("doesn't let a student confirm a lesson") do
      sign_in(@student)
      expect{ subject }.to_not change{ @lesson.confirmed }
    end

    it("doesn't let a non-student confirm a lesson") do
      sign_in(@user)
      expect{ subject }.to_not change{ @lesson.confirmed }
    end

    it("doesn't let a non-user confirm a lesson") do
      expect{ subject }.to_not change{ @lesson.confirmed }
      expect(response).to redirect_to(new_user_session_path)
    end

    it("can confirm multiple lessons") do
      sign_in(@student)
      time = (DateTime.now.utc + 7.days).strftime("%a %b %e") + " 08:00"
      expect{ 
        post :create, params: {
          time: time,
          location: "teacher",
          length: "60",
          occurence: "weekly"
        }
      }.to change{ Lesson.count }.by(4)
      sign_out(@student)
      sign_in(@teacher)
      lesson = Lesson.all.order(:start_time).second
      patch :update, params: { id: lesson.id, occurence: "weekly" } 
      expect{ lesson.reload }.to change{ lesson.confirmed }.from(false).to(true)
      3.times do 
        lesson = Lesson.find_by(start_time: lesson.start_time + 1.week)
        expect(lesson.confirmed).to eq(true)
      end
    end
  end

  describe('DELETE #destroy') do
    before(:each) do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.teacher = @teacher
      @lesson.student = @student
      @lesson.save!
      @student2 = create(:student2)
    end

    subject { delete :destroy, params: { id: @lesson.id } }

    it('allows a teacher to delete a lesson') do
      sign_in(@teacher)
      expect{ subject }.to change{ Lesson.count }.by(-1).and change{ ActionMailer::Base.deliveries.length }.by(1)
      expect(response).to redirect_to root_path
    end

    it('allows a student to delete their own lesson') do
      sign_in(@student)
      expect{ subject }.to change{ Lesson.count }.by(-1) 
      expect(response).to redirect_to root_path
    end

    it('allows deletion of repeated lessons') do
      3.times do |n|
        lesson = Lesson.new(start_time: @lesson.start_time + (1 + n).weeks, end_time: @lesson.end_time + (1 + n).weeks, location: @lesson.location, student_id: @student.id, teacher_id: @teacher.id, confirmed: true)
        lesson.repeat = true if n == 2
        lesson.save!
      end
      sign_in(@teacher)
      expect{
        delete :destroy, params: { id: @lesson.id, destroy_all: true }
      }.to change{ Lesson.count }.by(-4)
    end

    it("doesn't allow a non-student to delete a lesson") do
      sign_in(@user)
      expect{ subject }.to change{ Lesson.count }.by(0) 
    end

    it("doesn't allow a non-user to delete a lesson") do
      expect{ subject }.to change{ Lesson.count }.by(0) 
    end

    it("doesn't allow a student to delete someone else's lesson") do
      sign_in(@student2)
      expect{ subject }.to change{ Lesson.count }.by(0) 
    end

    it("doesn't allow a student to delete a lesson within 24 hours of now") do
      @lesson.update_attribute(:start_time, Time.now + 23.hours + 50.minutes)
      sign_in(@student)
      expect{ subject }.to change{ Lesson.count }.by(0)
    end

    it("does allow a teacher to delete a lesson within 24 hours of now") do
      @lesson.update_attribute(:start_time, Time.now + 23.hours + 50.minutes)
      sign_in(@teacher)
      expect{ subject }.to change{ Lesson.count }.by(-1)
    end

    describe("deleting recurring lessons") do
      before(:each) do
        3.times do |n|
          lesson = Lesson.new(start_time: @lesson.start_time + (n + 1).weeks, end_time: @lesson.end_time + (n + 1).weeks, location: "teacher")
          lesson.student = @student
          lesson.teacher = @teacher
          lesson.repeat = true if n == 2
          lesson.save!
        end
      end
      
      it("allows deleting all recurring lessons") do
        expect(Lesson.count).to eq(4)
        sign_in(@teacher)
        expect{
          delete :destroy, params: { id: @lesson.id, destroy_all: true }
        }.to change{ Lesson.count }.by(-4)
      end

      it("doesn't delete all recurring lessons at single time if they are not with same student") do
        Lesson.last.update_attribute(:student, @student2)
        sign_in(@teacher)
        expect{
          delete :destroy, params: { id: @lesson.id, destroy_all: true }
        }.to change{ Lesson.count }.by(-3)
      end

      it("if choosing a lesson that repeats but single lesson option, can delete only that one lesson but still have repeating lessons") do
        sign_in(@teacher)
        lesson = Lesson.where(repeat: true).first
        expect{
          delete :destroy, params: { id: lesson.id, }
        }.to change{ Lesson.count }.by(0)
      end
    end
  end

  describe("GET #show") do
    before(:each) do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.confirmed = true
      @lesson.save
    end

    subject { get :show, params: { id: @lesson.id } }

    it('gets a lesson for the teacher') do
      sign_in(@teacher)
      subject
      expect(response).to be_ok
    end

    it('gets a lesson for the student') do
      sign_in(@student)
      subject
      expect(response).to be_ok
    end

    it("Doesn't get a lesson for a student from another student") do
      @student2 = create(:student2)
      sign_in(@student2)
      subject
      expect(response).to redirect_to(root_path)
    end

    it("doesn't get an unconfirmed lesson for a student") do
      @lesson.update_attribute(:confirmed, false)
      sign_in(@student)
      subject
      expect(response).to redirect_to(root_path)
    end

    it('does get an unconfirmed lesson for a teacher') do
      @lesson.update_attribute(:confirmed, false)
      sign_in(@teacher)
      subject
      expect(response).to be_ok
    end

    it("doesn't allow a non-student to get a lesson") do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
   end

    it("doesn't allow a non-user to get a lesson") do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
