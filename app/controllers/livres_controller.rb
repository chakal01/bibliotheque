class LivresController < ApplicationController
  before_action :set_livre, only: [:show, :edit, :update, :destroy]
  before_action :set_listes, only: [:show, :edit, :update, :destroy, :create, :new]
  before_filter :init
  autocomplete :auteur, :nom, full: true
  autocomplete :edition, :nom, full: true
  autocomplete :genre, :nom, full: true
  autocomplete :emplacement, :nom, full: true


  def init
    @title = "Mes Livres"
  end

  # GET /livres
  # GET /livres.json
  def index
    if params[:search]
      @livres = Livre.where("LOWER(titre) like LOWER(?)", "%#{params[:search]}%")
    else
      @livres = Livre.all
    end

    @livres = @livres.order(:titre).includes(:auteur, :edition, :genre, :emplacement).paginate( page: params[:page], per_page: 18)
  end

  # GET /livres/1
  # GET /livres/1.json
  def show
  end

  # GET /livres/new
  def new
    @livre = Livre.new
  end

  # GET /livres/1/edit
  def edit
  end

  # POST /livres
  # POST /livres.json
  def create
    @livre = Livre.new(livre_params)
    if @livre.couverture
      uploader = ImageUploader.new
      uploader.store!(@livre.couverture)
    end

    respond_to do |format|
      if @livre.save
        format.html { redirect_to livres_path, notice: 'Livre was successfully created.' }
        format.json { render :show, status: :created, location: @livre }
      else
        format.html { render :new }
        format.json { render json: @livre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /livres/1
  # PATCH/PUT /livres/1.json
  def update
    respond_to do |format|
      if @livre.update(livre_params)
        format.html { redirect_to @livre, notice: 'Livre was successfully updated.' }
        format.json { render :show, status: :ok, location: @livre }
      else
        format.html { render :edit }
        format.json { render json: @livre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /livres/1
  # DELETE /livres/1.json
  def destroy
    @livre.destroy
    respond_to do |format|
      format.html { redirect_to livres_url, notice: 'Livre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_livre
      @livre = Livre.find(params[:id])
      if @livre.couverture
        uploader = ImageUploader.new
        uploader.retrieve_from_store!(@livre.couverture)
      end
    end

    def set_listes
      @auteurs = Auteur.all.map{|a| [a.nom, a.id]}
      @editions = Edition.all.map{|a| [a.nom, a.id]}
      @genres = Genre.all.map{|a| [a.nom, a.id]}
      @emplacements = Emplacement.all.map{|a| [a.nom, a.id]}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def livre_params
      params.require(:livre).permit(:titre, :auteur_nom, :edition_nom, :genre_nom, :emplacement_nom, :parution, :achat, :couverture)
    end
end
