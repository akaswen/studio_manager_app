class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def index
    @payments = Payment.all
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

  private
    def payment_params
      params.require(:payment).permit(:amount, :user_id)
    end
end
