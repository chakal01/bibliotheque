class Genre < ActiveRecord::Base
	validates :nom, presence: true, uniqueness: true
end
