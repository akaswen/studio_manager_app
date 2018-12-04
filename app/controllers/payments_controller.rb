class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def index
    if (params[:year])
      @payments =  Payment.where("created_at > ? AND created_at < ?", DateTime.parse("jan 1 #{params[:year]}"), DateTime.parse("jan 1 #{params[:year]}") + 1.year)
    else
      @payments = Payment.all
    end
    @total = @payments.inject(0.0) { |sum, p| sum + p.amount }
    @total = (@total * 100).round / 100.0
    @years = Payment.years
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      payment.pay
      flash["notice"] = "Payment has been added"
    else 
      payment.errors.full_messages.each do |fm|
        flash["alert"] = fm
      end
    end
    redirect_to dashboard_path
  end

  def destroy
    payment = Payment.find(params[:id])
    student = payment.user
    amount = payment.amount

    credit = student.credit
    if credit - amount >= 0
      student.update_attribute(:credit, credit - amount)
      amount -= credit
    end

    paid_lessons = student.learning_lessons.where("start_time > ? AND paid = ?", Time.now, true).order(start_time: "desc")
    paid_lessons.each do |pl|
      if amount > 0
        amount -= pl.price
        pl.update_attribute(:paid, false)
      end
    end

    student.update_attribute(:credit, student.credit - amount)

    payment.destroy
    redirect_to payments_path
  end

  private
    def payment_params
      params.require(:payment).permit(:amount, :user_id)
    end
end
