class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_format_of :email, with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  before_save :lower_case

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end

  private

  def lower_case
    first_name.downcase!
    last_name.downcase!
  end
end
