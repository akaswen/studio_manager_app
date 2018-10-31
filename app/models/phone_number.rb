class PhoneNumber < ApplicationRecord
  belongs_to :user

  validates :number, presence: true, format: { with: /\A(\D*\d\D*){10}\Z/ }

  validates_presence_of :kind

  before_validation :downcase_kind, :validate_kind
  before_save :adjust_number

  def pretty_number
    n = self.number
    "(#{n.slice(0, 3)}) #{n.slice(3, 3)} - #{n.slice(6, 4)}"
  end

  private

  def adjust_number
    self.number = self.number.split(/\D/).join
  end

  def downcase_kind
    kind.downcase!
  end

  def validate_kind
    unless self.kind.match(/\A(home|mobile|work)\Z/)
      errors.add(:kind, message: "Must be either home, mobile, or work")
    end
  end
end
