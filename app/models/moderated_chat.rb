class ModeratedChat < ActiveRecord::Base
  belongs_to :from_user, :foreign_key => 'from_user_id', class_name: 'User'
  belongs_to :to_user, :foreign_key => 'to_user_id', class_name: 'User'
  belongs_to :webcast

  validates :from_user, associated: true, presence: true
  validates :message, presence: true
end
