class Literature < ActiveRecord::Base
  resourcify
  belongs_to :asset_type
  belongs_to :user
  belongs_to :hall, -> { where('hall_type = ?', 'Knowledge Library') }
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :booths

  validates :name, :user, presence: true

  has_attached_file :file

  validates_attachment_content_type :file, 
    :content_type => /^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.presentation|vnd.openxmlformats-officedocument.wordprocessingml.document|pdf)/,
    :default_url => nil,
    :message => "only powerpoint, word and pdf files are allowed and should not exceed 50 megabytes",
    :size => { :in => 0..50000.kilobytes }
end
