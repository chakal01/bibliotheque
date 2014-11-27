class ParametresController < ApplicationController
  def index
  	@title = "Paramètres"
  	@user = User.new
  end

  def save
  	puts params
  	session[:modification] = params[:parametres][:modification] == "1"
  	session[:bookPerPage] = params[:parametres][:nb_pages]
  	redirect_to parametres_path
  end
end
