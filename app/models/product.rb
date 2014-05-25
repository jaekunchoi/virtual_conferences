class Product < ActiveRecord::Base
  include PaperclipUploadedFile

  resourcify

  belongs_to :user
  has_and_belongs_to_many :booths

  paperclip_file uploaded_file: nil

  validates :name, :description, presence: true
  validates :user, associated: true, presence: true
  # validates :product_url, url: true, presence: false
end
