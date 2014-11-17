class Livre < ActiveRecord::Base
  belongs_to :auteur
  belongs_to :edition
  belongs_to :genre
  belongs_to :emplacement
  validates :titre, presence: true
end
