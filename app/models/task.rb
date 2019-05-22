class Task < ApplicationRecord
  attr_default :done, false
  belongs_to :user

  validates_presence_of :title, :user_id
end
