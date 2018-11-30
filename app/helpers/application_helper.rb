module ApplicationHelper
  def dollar_prettified(float)
    float_string = float.to_s
    float_string += "0" if float_string.split('.')[-1].length == 1
    prettified = "$#{float_string}"
  end
end
