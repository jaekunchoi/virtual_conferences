class WebcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :webcast_type, :media_type, :details, :background_colour
  has_one :hall
  has_one :user
  has_one :template
end
