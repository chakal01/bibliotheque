class AuteursController < ApplicationController
  before_action :set_auteur, only: [:show, :edit, :update, :destroy]
  before_filter :init

  def init
    @title = "Auteurs"
  end

  def autocomplete_auteur_nom
    @auteurs = Auteur.order(:nom).where("LOWER(nom) like LOWER(?)", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @auteurs.map(&:nom) }
    end
  end

  # GET /auteurs
  # GET /auteurs.json
  def index
    if params[:search]
      @auteurs = Auteur.where("LOWER(nom) like LOWER(?)", "%#{params[:search]}%")
    else
      @auteurs = Auteur.all
    end
    @auteurs = @auteurs.order(:nom).paginate( page: params[:page], per_page: 18)
  end

  # GET /auteurs/1
  # GET /auteurs/1.json
  def show
  end

  # GET /auteurs/new
  def new
    @auteur = Auteur.new
  end

  # GET /auteurs/1/edit
  def edit
  end

  # POST /auteurs
  # POST /auteurs.json
  def create
    @auteur = Auteur.new(auteur_params)
    if @auteur.photo
      uploader = ImageUploader.new
      uploader.store!(@auteur.photo)
    end
    respond_to do |format|
      if @auteur.save
        format.html { redirect_to @auteur, notice: 'Auteur was successfully created.' }
        format.json { render :show, status: :created, location: @auteur }
      else
        format.html { render :new }
        format.json { render json: @auteur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auteurs/1
  # PATCH/PUT /auteurs/1.json
  def update
    respond_to do |format|
      if @auteur.update(auteur_params)
        format.html { redirect_to @auteur, notice: 'Auteur was successfully updated.' }
        format.json { render :show, status: :ok, location: @auteur }
      else
        format.html { render :edit }
        format.json { render json: @auteur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auteurs/1
  # DELETE /auteurs/1.json
  def destroy
    @auteur.destroy
    respond_to do |format|
      format.html { redirect_to auteurs_url, notice: 'Auteur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auteur
      @auteur = Auteur.find(params[:id])
      if @auteur.photo
        uploader = ImageUploader.new
        uploader.retrieve_from_store!(@auteur.photo)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auteur_params
      params.require(:auteur).permit(:nom, :photo, :nationalite, :naissance, :mort)
    end
end
