class Livre < ActiveRecord::Base
  belongs_to :auteur
  belongs_to :edition
  belongs_to :genre
  belongs_to :emplacement
  validates :titre, presence: true
  mount_uploader :couverture, ImageUploader

  def auteur_nom
    auteur.nom if auteur
  end

  def auteur_nom=(nom)
    self.auteur = Auteur.find_or_create_by(nom: nom) unless nom.blank?
  end

  def edition_nom
    edition.nom if edition
  end

  def edition_nom=(nom)
    self.edition = Edition.find_or_create_by(nom: nom) unless nom.blank?
  end
  
  def genre_nom
    genre.nom if genre
  end

  def genre_nom=(nom)
    self.genre = Genre.find_or_create_by(nom: nom) unless nom.blank?
  end
  
  def emplacement_nom
    emplacement.nom if emplacement
  end

  def emplacement_nom=(nom)
    self.emplacement = Emplacement.find_or_create_by(nom: nom) unless nom.blank?
  end


end
