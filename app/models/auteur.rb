class Auteur < ActiveRecord::Base
	validates :nom, presence: true
end
