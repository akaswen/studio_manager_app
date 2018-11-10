class StaticPagesController < ApplicationController
  def home
    @teacher = User.where(teacher: true).first
  end

  def about
  end
end
