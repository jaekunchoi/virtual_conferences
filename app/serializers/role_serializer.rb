class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name
  # has_many :users, embed: :ids, :key => 'users'
end