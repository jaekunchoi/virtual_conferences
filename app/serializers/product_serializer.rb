class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :product_url, :image_id, :request_info, :email_notification, :emails, :created_at, :updated_at
  has_one :user
end
