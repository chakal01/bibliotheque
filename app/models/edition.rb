class Edition < ActiveRecord::Base
	has_many :livres
	validates :nom, presence: true, uniqueness: true
end
