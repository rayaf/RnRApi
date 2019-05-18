class Task < ApplicationRecord
  attr_default :done, false
  belongs_to :user
end
