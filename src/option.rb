class Option < ActiveRecord::Base
  validates_presence_of :name, message: "Email cannot be blank."
end
