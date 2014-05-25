class ModeratedChatSerializer < ActiveModel::Serializer
  attributes :id, :message, :from_user_id, :to_user_id, :approved
  has_one :webcast
end
