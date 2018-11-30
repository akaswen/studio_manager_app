require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  it('returns a prettified string') do
    expect(dollar_prettified(400.0)).to eq('$400.00')
  end

  it('works for two decimal points') do
    expect(dollar_prettified(45.44)).to eq('$45.44')
  end
end
