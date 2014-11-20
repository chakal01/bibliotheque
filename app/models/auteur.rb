class Auteur < ActiveRecord::Base
	has_many :livres
	validates :nom, presence: true
	mount_uploader :photo, ImageUploader
end
