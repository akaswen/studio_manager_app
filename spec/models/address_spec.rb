require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:each) do
    @address = build(:address)
  end  

  it('should be valid') do
    expect(@address).to be_valid
  end
end
