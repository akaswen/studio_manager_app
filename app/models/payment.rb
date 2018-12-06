class Payment < ApplicationRecord
  belongs_to :user

  validates_presence_of :amount

  before_validation :check_user, :check_amount
  before_save :round_amount

  default_scope { order("created_at DESC") }

  def pay
    student = self.user
    student_credit = student.credit
    credit = self.amount
    lessons = Lesson.where(student_id: student.id, paid: false)
    unless lessons.empty?
      lessons.each do |l|
        if credit - l.price >= 0
          credit -= l.price
          l.update_attribute(:paid, true)
        elsif student_credit + credit - l.price >= 0
          student_credit -= l.price - credit
          credit = 0
          l.update_attribute(:paid, true)
          student.update_attribute(:credit, student_credit)
        end
      end
    end
    student.update_attribute(:credit, student.credit + credit)
  end

  def pretty_amount
    amount_string = self.amount.to_s
    amount_string += "0" if amount_string.split('.')[-1].length == 1
    prettified = "$#{amount_string}"
  end

  def self.years
    years = []
    earliest_year = Payment.last.created_at.strftime('%Y').to_i
    latest_year = Payment.first.created_at.strftime('%Y').to_i
    until latest_year < earliest_year
      years << latest_year.to_s
      latest_year -= 1
    end
    years
  end

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
