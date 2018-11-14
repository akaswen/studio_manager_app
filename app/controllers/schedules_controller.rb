class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def edit
    @schedule = User.teacher.schedule
  end
end
