class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :title, :first_name, :last_name, :position, :work_phone, :company, :sign_in_count, :last_sign_in_ip, :confirmed_at, :created_at
  has_many :roles, embed: :ids, :key => "roles"
end
