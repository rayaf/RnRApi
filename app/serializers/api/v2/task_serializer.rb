class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :deadline, :done, :user_id, :created_at, :updated_at,
              :short_description, :late?

  def short_description
    object.description[0..40] if object.description.present?
  end

  def late?
    Time.current > object.deadline if object.deadline.present?
  end

  belongs_to :user
end
