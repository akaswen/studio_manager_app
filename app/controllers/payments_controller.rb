class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def create
    payment = Payment.new(payment_params)
    payment.save
    payment.pay
  end

  private
    def payment_params
      params.require(:payment).permit(:amount, :user_id)
    end
end
