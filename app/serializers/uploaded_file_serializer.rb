class UploadedFileSerializer < ActiveModel::Serializer
  attributes :id, :file_id, :name, :file_group, :saved_file_name, :mime_type
end
