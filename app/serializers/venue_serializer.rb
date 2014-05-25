class VenueSerializer < ActiveModel::Serializer
  attributes :id, :name, :colour, :logo, :background_image
  has_one :user
end
