class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def edit
    @schedule = current_user.schedule
  end
end
