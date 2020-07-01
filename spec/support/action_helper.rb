# frozen_string_literal: true

module ActionHelper
  def format_time_key(time_key)
    time_key = "0#{time_key}" if time_key.length == 3
    minutes = time_key.last(2)
    if minutes == '00'
      Time.strptime(time_key, '%H%M').strftime('%l %p').lstrip
    else
      Time.strptime(time_key, '%H%M').strftime('%l:%M %p').lstrip
    end
  end
end
