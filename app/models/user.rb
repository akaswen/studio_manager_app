class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_one :address, dependent: :destroy
  has_one :phone_number, dependent: :destroy
  has_many :teaching_lessons, foreign_key: :teacher_id, class_name: "Lesson", dependent: :destroy
  has_many :learning_lessons, foreign_key: :student_id, class_name: "Lesson", dependent: :destroy
  has_many :payments, dependent: :destroy

  has_one :schedule, dependent: :destroy

  accepts_nested_attributes_for :address, :phone_number

  validates_presence_of :first_name, :last_name, :address, :phone_number
  validates_format_of :email, with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates_format_of :password, with: /(?=.*[A-Z])(?=.*[0-9])/

  before_save :lower_case

  def self.active 
    where(active: true)
  end

  def self.confirmed
    where('confirmed_at IS NOT NULL')
  end

  def self.teacher
    where(teacher: true).first
  end

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end

  def rate
    "$#{self.rate_per_hour}/h" if self.rate_per_hour
  end

  private

  def lower_case
    first_name.downcase!
    last_name.downcase!
  end
end
