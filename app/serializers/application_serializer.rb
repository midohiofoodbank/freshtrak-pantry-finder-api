# frozen_string_literal: true

# All other serializer inherit from ApplicationSerializer.
class ApplicationSerializer < ActiveModel::Serializer
  def start_time
    format_time_key(object.start_time_key.to_s)
  end

  def end_time
    format_time_key(object.end_time_key.to_s)
  end

  private

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
