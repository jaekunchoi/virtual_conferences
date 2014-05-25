class Webcast < ActiveRecord::Base
  resourcify
  belongs_to :hall, -> { where hall_type: "Knowledge Library" }
  belongs_to :user
  belongs_to :template

  has_many :moderated_chats
  has_many :chats, as: :chattable, dependent: :destroy
  accepts_nested_attributes_for :chats

  store_accessor :widget_locations, :leftarea1, :midarea1, :leftarea2, :midarea2, :rightarea2

  validates :name, :user, :template, presence: :true

end
