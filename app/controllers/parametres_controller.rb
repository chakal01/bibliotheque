class ParametresController < ApplicationController
  def index
  	@title = "Paramètres"
  	@user = User.new
  end

  def save
  	puts params
    cookies.permanent[:onglet_livres] = (params[:parametres][:onglet_livres]=="on")
    cookies.permanent[:onglet_auteurs] = (params[:parametres][:onglet_auteurs]=="on")
    cookies.permanent[:onglet_genres] = (params[:parametres][:onglet_genres]=="on")
    cookies.permanent[:onglet_editions] = (params[:parametres][:onglet_editions]=="on")
    cookies.permanent[:onglet_emplacements] = (params[:parametres][:onglet_emplacements]=="on")
    cookies.permanent[:onglet_scans] = (params[:parametres][:onglet_scans]=="on")
  	cookies.permanent[:bookPerPage] = params[:parametres][:nb_livre_page]
    cookies.permanent[:authorPerPage] = params[:parametres][:nb_auteur_page]
  	redirect_to parametres_path
  end
end
