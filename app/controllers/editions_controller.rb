class EditionsController < ApplicationController
  before_action :set_edition, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :fusion, :fusionner]
  before_filter :init

  def init
    @title = "Editions"
  end

  def autocomplete_edition_nom
    @editions = Edition.order(:nom).where("LOWER(nom) like LOWER(?)", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @editions.map(&:nom) }
    end
  end

  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.order(:nom)
    @edition = Edition.new
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
    @liste_by_auteur = @edition.livres.includes(:auteur).group_by{|livre| livre.auteur.nom}
  end

  # GET /editions/new
  def new
    @edition = Edition.new
  end

  # GET /editions/1/edit
  def edit
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.new(edition_params)
    if @edition.nom.present? && @edition.save
      flash[:notice] = "Edition \"#{@edition.nom}\" créé."
    else
      flash[:error] = @edition.errors.full_messages.join(',')
    end
    redirect_to editions_path
  end

  # PATCH/PUT /editions/1
  # PATCH/PUT /editions/1.json
  def update
    if @edition.nom.present? && @edition.update(edition_params)
      flash[:notice] = "Edition \"#{@edition.nom}\" modifié."
    else
      flash[:error] = @edition.errors.full_messages.join(',')
    end
    redirect_to editions_path
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    @edition.livres.each do |livre|
      livre.edition_id = nil
      livre.save
    end
    @edition.delete
    redirect_to editions_url, notice: 'Edition supprimée.'
  end

  def fusion
    @editions = Edition.order(:nom)
  end

  def fusionner
    liste = params["/editions/fusion"].select{|id,bool| bool=="1"}.map{|id,bool| id}
    editions = Edition.find(liste)
    id_to_keep = editions.first.id
    editions.each do |edition|
      if edition.id != id_to_keep
        Livre.where(edition_id: edition.id).each do |livre|
          livre.edition_id = id_to_keep
          livre.save
        end
        edition.destroy
      end 
    end
    redirect_to editions_url, notice: "Fusion effectuée."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition
      @edition = Edition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edition_params
      params.require(:edition).permit(:nom)
    end
end
