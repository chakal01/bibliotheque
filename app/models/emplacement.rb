class Emplacement < ActiveRecord::Base
	validates :nom, presence: true
end
