module PaperclipUploadedFile
  extend ActiveSupport::Concern

  module ClassMethods
    def paperclip_file(fields)
      fields.each_pair do |fieldName, uploadedFileType|
        has_one fieldName, ->{where(:image_type => uploadedFileType)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
        accepts_nested_attributes_for fieldName, :reject_if => proc { |attributes| attributes['assets'].blank? }
      end
    end
  end
end

ActiveRecord::Base.send(:include, PaperclipUploadedFile)