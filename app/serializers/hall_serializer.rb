class HallSerializer < ActiveModel::Serializer
  attributes :id, :name, :template_id, :background_id, :colour, :greeting, :greeting_type, :greeting_enable, :jumbotron, :jumbotron_enable
end
