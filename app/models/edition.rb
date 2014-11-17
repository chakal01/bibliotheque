class Edition < ActiveRecord::Base
	validates :nom, presence: true
end
