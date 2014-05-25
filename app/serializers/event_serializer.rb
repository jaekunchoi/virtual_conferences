class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :start, :finish, :event_reports_url, :colour, :publish_event, :description, :search_keywords, :closed_event_redirect, :comments
  has_one :venue
end
