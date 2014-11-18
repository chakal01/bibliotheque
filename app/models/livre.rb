class Livre < ActiveRecord::Base
  belongs_to :auteur
  belongs_to :edition
  belongs_to :genre
  belongs_to :emplacement
  validates :titre, presence: true

  def auteur_nom
    auteur.nom if auteur
  end

  def auteur_nom=(nom)
    self.auteur = Auteur.find_or_create_by(nom: nom) unless nom.blank?
  end


end
