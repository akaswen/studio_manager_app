class Address < ApplicationRecord
  belongs_to :user

  validates :street_address, format: { with: /\A\d+(\s\w+){2}/ }
  validates_presence_of :street_address, :city, :state, :zip_code
  validates :state, length: { is: 2 }
  validates :zip_code, format: { with: /\A\d{5}\Z/ }

  before_save :upcase_state

  private

  def upcase_state
    state.upcase!
  end
end
