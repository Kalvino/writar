module Navigatable
  extend ActiveSupport::Concern

  included do
  end

  def next
    self.class.where("id > ? ", id).order("id ASC").first
  end

  def previous
    self.class.where("id < ? ", id).order("id DESC").first
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

  end
end
