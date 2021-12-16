module Filterable
  extend ActiveSupport::Concern

  included do
    scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
    scope :yesterday, -> { where("created_at >= ? and created_at <= ?", (Time.zone.now - 1.day).beginning_of_day.in_time_zone, Time.zone.now.beginning_of_day) }
    scope :this_week, -> { where("created_at >= ?", Time.zone.now.beginning_of_week) }
    scope :this_month, -> { where("created_at >= ?", Time.zone.now.beginning_of_month) }
    scope :this_year, -> { where("created_at >= ?", Time.zone.now.beginning_of_year) }
    scope :past_7_days, -> { where("created_at >= ?", 1.week.ago.beginning_of_day) }
    scope :past_30_days, -> { where("created_at >= ?", 30.days.ago.beginning_of_day) }
    scope :between, -> (time1,time2) { where("created_at >= ? AND created_at <= ?", time1.in_time_zone, time2.in_time_zone) }
    scope :year, ->(year) { where("extract(year from created_at) = ?", year ) }
  end

  def day
    self.created_at.strftime("%d-%m-%Y")
  end

  def month
    self.created_at.strftime("%B")
  end

  def year
    self.created_at.strftime("%Y")
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

  end
end
