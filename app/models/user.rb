class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  validates_presence_of :first_name, :last_name
  validates_format_of :email, with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates_format_of :password, with: /(?=.*[A-Z])(?=.*[0-9])/

  before_save :lower_case

  has_many :addresses

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end

  private

  def lower_case
    first_name.downcase!
    last_name.downcase!
  end
end
