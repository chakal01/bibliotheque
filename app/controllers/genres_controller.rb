class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :fusion, :fusionner]
  before_filter :init

  def init
    @title = "Genres"
  end

  def autocomplete_genre_nom
    @genres = Genre.order(:nom).where("LOWER(nom) like LOWER(?)", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @genres.map(&:nom) }
    end
  end

  # GET /genres
  # GET /genres.json
  def index
    @genres = Genre.order(:nom)
    @genre = Genre.new
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(genre_params)
    if @genre.nom.present? && @genre.save
      flash[:notice] = "Genre \"#{@genre.nom}\" créé."
    else
      flash[:error] = "Genre \"#{@genre.nom}\" existe déjà."
    end
    redirect_to genres_path
  end

  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    if @genre.nom.present? && @genre.update(genre_params)
      flash[:notice] = "Genre \"#{@genre.nom}\" modifié."
    else
      flash[:error] = "Genre \"#{@genre.nom}\" existe déjà."
    end
    redirect_to genres_path
  end

  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    @genre.livres.each do |livre|
      livre.genre_id = nil
      livre.save
    end
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_url, notice: "Genre \"#{@genre.nom}\" a bien été supprimé." }
      format.json { head :no_content }
    end
  end

  def fusion
    @genres = Genre.order(:nom)
  end

  def fusionner
    liste = params["/genres/fusion"].select{|id,bool| bool=="1"}.map{|id,bool| id}
    genres = Genre.find(liste)
    id_to_keep = genres.first.id
    genres.each do |genre|
      if genre.id != id_to_keep
        Livre.where(genre_id: genre.id).each do |livre|
          livre.genre_id = id_to_keep
          livre.save
        end
        genre.destroy
      end 
    end
    redirect_to genres_url, notice: "Fusion effectuée."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def genre_params
      params.require(:genre).permit(:nom)
    end

end
