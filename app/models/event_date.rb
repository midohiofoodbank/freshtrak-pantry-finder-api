# frozen_string_literal: true

# A date when an event is happening
class EventDate < ApplicationRecord
  alias_attribute :id, :event_date_id
  alias_attribute :date, :event_date_key

  belongs_to :event, foreign_key: :event_id, inverse_of: :event_dates
  has_many :event_hours, foreign_key: :event_date_id, inverse_of: :event_date,
                         dependent: :restrict_with_exception

  default_scope { active.published.event_publishes_dates.future }
  scope :active, lambda {
    where('event_dates.status_id = 1 AND ? <= published_end_datetime',
          DateTime.current.utc.strftime('%Y-%m-%d %H:%M:%S'))
  }
  scope :event_publishes_dates, lambda {
    joins(:event).merge(Event.publishes_dates)
  }
  scope :published, lambda {
    where('published_date_key <= ?', Date.today.to_s.delete('-'))
      .where(status_publish: 1)
  }
  scope :future, lambda {
    where('event_date_key >= ?', Date.today.to_s.delete('-'))
  }

  def valid_registration
    published? && capacity_not_full? && still_open?
  end

  def published?
    status_publish == 1 && published_date_key <= Date.today.to_s.delete('-').to_i
  end

  def capacity_not_full?
    reserved.to_i < capacity.to_i
  end

  def still_open?
    DateTime.current < published_end_datetime
  end

end
