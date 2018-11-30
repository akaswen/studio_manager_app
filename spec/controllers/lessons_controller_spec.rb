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
            lesson = Lesson.new(start_time: start_time, end_time: start_time + 1.hour, location: "teacher", kind: "voice")
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
      occurence: "single",
      kind: "voice"
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
          occurence: "weekly",
          kind: "voice"
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
          id: @student.id,
          kind: "voice"
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
      @lesson = Lesson.create!(start_time: DateTime.now.utc.beginning_of_day + 31.days + 8.hours, end_time: DateTime.now.utc.beginning_of_day + 31.days + 9.hours, location: "teacher", student_id: @student.id, teacher_id: @teacher.id, kind: "voice")
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

    it("has a status of paid if there is enough credit for a user") do
      @student.update_attribute(:credit, 100.0)
      sign_in(@student)
      subject
      expect(Lesson.last.paid).to eq(true)
      expect{ @student.reload }.to change{ @student.credit }.from(100.0).to (55.0)
    end
  end

  describe('PATCH #update') do
    before(:each) do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.save
    end

    it("doesn't let a student update a lesson") do
      sign_in(@student)
      patch :update, params: { id: @lesson.id }
      expect(response).to redirect_to(root_path)
    end

    it("doesn't let a non-student update a lesson") do
      sign_in(@user)
      patch :update, params: { id: @lesson.id }
      expect(response).to redirect_to(root_path)
   end

    it("doesn't let a non-user update a lesson") do
      patch :update, params: { id: @lesson.id }
      expect(response).to redirect_to(new_user_session_path)
   end

    describe('confirming a lesson') do
      before(:each) do
        sign_in(@teacher)
        request.env['HTTP_REFERER'] = '/'
      end

      subject { patch :update, params: { id: @lesson.id, attribute: "confirmed", value: "true", occurence: "single" } }

      it("confirms a lesson") do
        expect{ subject }.to change{ ActionMailer::Base.deliveries.length }.by(1)
        expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
      end

      it("can confirm multiple lessons") do
        make_recurring(@lesson, false)
        sign_in(@teacher)
        patch :update, params: { id: @lesson.id, attribute: "confirmed", value: "true", occurence: "weekly" } 
        expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
        3.times do |n|
          lesson = Lesson.find_by(start_time: @lesson.start_time + (1 + n).weeks)
          expect(lesson.confirmed).to eq(true)
        end
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
      make_recurring(@lesson)
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

    describe('deleting paid lessons') do
      before(:each) do
        @lesson.update_attribute(:paid, true)
        @lesson2 = Lesson.new(attributes_for(:lesson2))
        @lesson2.student = @lesson.student
        @lesson2.teacher = @lesson.teacher
        @lesson2.save!
        sign_in(@teacher)
      end

      it ("finds the next unpaid lesson of student to mark as paid if deleting a paid lesson") do
        subject
        expect{ @lesson2.reload }.to change{ @lesson2.paid }.from(false).to(true)
      end

      it("uses amount from paid lesson combined with credit to pay for next lesson if deleting paid and saves rest to credit") do
        @lesson.update_attribute(:end_time, @lesson.end_time + 30.minutes)
        subject
        expect{ @lesson2.reload }.to change{ @lesson2.paid }.from(false).to(true)
        expect(@lesson2.student.credit).to eq(22.5)
      end

      it("adds to credit of student if deleting a paid lesson with no other unpaid lessons") do
        @lesson2.update_attribute(:paid, true)
        subject
        @lesson2.reload
        expect(@lesson2.student.credit).to eq(45)
      end

      it("doesn't allow deleting of paid and taught lessons") do
        @lesson.update_attribute(:start_time, Time.now - 1.hour)
        @lesson.update_attribute(:end_time, Time.now)
        expect{ subject }.to change{ Lesson.count }.by(0)
      end
    end

    describe("deleting recurring lessons") do
      before(:each) do
        make_recurring(@lesson)      
        sign_in(@teacher)
      end
      
      subject { delete :destroy, params: { id: @lesson.id, destroy_all: true } }

      it("allows deleting all recurring lessons") do
        expect(Lesson.count).to eq(4)
        expect{
          subject
        }.to change{ Lesson.count }.by(-4)
      end

      it("doesn't delete all recurring lessons at single time if they are not with same student") do
        Lesson.last.update_attribute(:student, @student2)
        expect{
          subject
        }.to change{ Lesson.count }.by(-3)
      end

      it("if choosing a lesson that repeats but single lesson option, can delete only that one lesson but still have repeating lessons") do
        lesson = Lesson.where(repeat: true).first
        expect{
          delete :destroy, params: { id: lesson.id, }
        }.to change{ Lesson.count }.by(0)
      end

      it("adds to user credit for multiple unpaid lessons") do
        @lesson.update_attribute(:paid, true)
        expect{ subject }.to change{ Lesson.count }.by(-4)
        expect{ @student.reload }.to change{ @student.credit }.from(0.0).to(45.0)
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
