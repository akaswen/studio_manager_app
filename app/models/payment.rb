class Payment < ApplicationRecord
  belongs_to :user

  validates_presence_of :amount

  before_validation :check_user, :check_amount
  before_save :round_amount

  private
    
    def check_user
      self.errors.add(:user, "user must be a student") unless self.user.student
    end

    def round_amount
      self.amount = (self.amount * 100).round / 100.0
    end

    def check_amount
      if self.amount
        self.errors.add(:amount, "amount must be greater than 0") if self.amount <= 0
      end
    end
end
