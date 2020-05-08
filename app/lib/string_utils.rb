# frozen_string_literal: true

# StringUtils class for global access
module StringUtils
  class << self
    # Determines if a string can be converted to a number
    def numeric?(string)
      !Float(string).nil?
    rescue StandardError, SecurityError
      false
    end
  end
end
