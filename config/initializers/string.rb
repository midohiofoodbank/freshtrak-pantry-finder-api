# frozen_string_literal: true

# extends String with numeric? method
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError, SecurityError
    false
  end
end
