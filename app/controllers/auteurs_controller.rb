class AuteursController < ApplicationController
  before_action :set_auteur, only: [:show, :edit, :update, :destroy, :avatar, :save_avatar]
  before_filter :init
  include ApplicationHelper

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
    if params[:page].present?
      session[:auteurs_pages] = params[:page]
    end
    if @auteurs.count > 18
      page = session[:auteurs_pages]
    end 
    @auteurs = @auteurs.order(:nom).paginate( page: page, per_page: 18)
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
        format.html { redirect_to @auteur, notice: "Auteur #{@auteur.nom} créé." }
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
        format.html { redirect_to @auteur, notice: "Auteur #{@auteur.nom} mis à jour." }
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
    @auteur.livres.each do |livre|
      livre.auteur_id = nil
      livre.save
    end
    @auteur.delete
    respond_to do |format|
      format.html { redirect_to auteurs_url, notice: "Auteur #{@auteur.nom} détruit." }
      format.json { head :no_content }
    end
  end

  def fusion
    if params[:search]
      @auteurs = Auteur.where("LOWER(nom) like LOWER(?)", "%#{params[:search]}%")
    else
      @auteurs = Auteur.all
    end
    @auteurs = @auteurs.order(:nom)
  end

  def choix_fusion
    liste = params["/auteurs/fusion"].select{|id,bool| bool=="1"}.map{|id,bool| id}
    @auteurs = Auteur.find(liste)
  end

  def fusionner
    id_to_keep = params["/auteurs/fusionner"]["master"]
    params["/auteurs/fusionner"]["ids"].keys.each do |id|
      Livre.where(auteur_id: id).each do |livre|
        livre.auteur_id = id_to_keep
        livre.save
      end
      Auteur.find(id).destroy if id != id_to_keep
    end
    redirect_to auteurs_url, notice: "Fusion effectuée."
  end

  def avatar
    @uris = []
    Google::Search::Image.new(:query => @auteur.nom).first(8).each do |image|
      @uris.push(image.uri)
    end
  end

  def save_avatar
    filename_image_down = download_image_from_url(params["/auteurs/#{@auteur.id}/avatar"]["uri"])
    File.open(filename_image_down, 'r') do |photo|
      @auteur.update(photo: photo)
      uploader = ImageUploader.new
      uploader.store!(@auteur.photo)
      @auteur.save
    end
    File.delete(filename_image_down) if File.exist?(filename_image_down)
    redirect_to auteur_url(@auteur)
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
