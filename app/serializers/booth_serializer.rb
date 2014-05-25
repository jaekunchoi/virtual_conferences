class BoothSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_website, :social_media, :contact_info, :email, :about_us, :created_at, :updated_at
  has_one :greeting_type
end
