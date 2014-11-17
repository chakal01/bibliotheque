class Genre < ActiveRecord::Base
	validates :nom, presence: true
end
