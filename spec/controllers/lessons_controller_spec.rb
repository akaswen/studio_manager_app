require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  before(:each) do
    @schedule = create(:schedule)
    @teacher = @schedule.user
    @student = create(:student)
    @user = create(:user)
    @user.confirm
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

    describe('getting lessons') do
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

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

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
  end

  describe('POST #update') do
    before(:each) do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.save
    end

    subject { patch :update, params: { id: [@lesson.id] } }

    it("confirms a lesson") do
      sign_in(@teacher)
      subject
      expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
      expect(response).to redirect_to(root_path)
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
      @lesson2 = Lesson.new(start_time: @lesson.start_time + 1.day, end_time: @lesson.end_time + 1.day, location: 'teacher')
      @lesson2.teacher = @teacher
      @lesson2.student = @student
      @lesson2.save
      sign_in(@teacher)
      patch :update, params: { id: [@lesson.id, @lesson2.id] } 
      expect{ @lesson.reload }.to change{ @lesson.confirmed }.from(false).to(true)
      expect{ @lesson2.reload }.to change{ @lesson2.confirmed }.from(false).to(true)
    end
  end
end
