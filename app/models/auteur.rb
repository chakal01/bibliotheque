class Auteur < ActiveRecord::Base
	has_many :livres, dependent: :destroy
	validates :nom, presence: true, uniqueness: true
	mount_uploader :photo, ImageUploader
end
