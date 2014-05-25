class Presentation < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :hall, -> { where('hall_type = ?', 'Knowledge Library') }
  has_and_belongs_to_many :booths

  validates :name, :presence => true

  has_attached_file :file

  validates_attachment_content_type :file, 
    :content_type => /^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.presentation|vnd.openxmlformats-officedocument.wordprocessingml.document|pdf)/,
    :default_url => nil,
    :message => "only powerpoint, word and pdf files are allowed and should not exceed 50 megabytes",
    :size => { :in => 0..50000.kilobytes }

  has_one :logo, ->{where(:image_type => UploadedFile::IMAGE_TYPE_PRESENTATION_LOGO)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
  accepts_nested_attributes_for :logo, :reject_if => proc { |attributes| attributes['assets'].blank? }
end
