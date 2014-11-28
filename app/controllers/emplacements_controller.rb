class EmplacementsController < ApplicationController
  before_action :set_emplacement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new]
  before_filter :init

  def init
    @title = "Emplacements"
  end
  
  def autocomplete_emplacement_nom
    @emplacements = Emplacement.order(:nom).where("LOWER(nom) like LOWER(?)", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @emplacements.map(&:nom) }
    end
  end

  # GET /emplacements
  # GET /emplacements.json
  def index
    @emplacements = Emplacement.all
    @emplacement = Emplacement.new
  end

  # GET /emplacements/1
  # GET /emplacements/1.json
  def show
    @liste_by_auteur = @emplacement.livres.includes(:auteur).group_by{|livre| livre.auteur.nom}
  end

  # GET /emplacements/new
  def new
    @emplacement = Emplacement.new
  end

  # GET /emplacements/1/edit
  def edit
  end

  # POST /emplacements
  # POST /emplacements.json
  def create
    @emplacement = Emplacement.new(emplacement_params)

    if @emplacement.nom.present? && @emplacement.save
      flash[:notice] = "emplacement \"#{@emplacement.nom}\" créé."
    else
      flash[:error] = @emplacement.errors.full_messages.join(',')
    end
    redirect_to emplacements_path
  end

  # PATCH/PUT /emplacements/1
  # PATCH/PUT /emplacements/1.json
  def update
    if @emplacement.nom.present? && @emplacement.update(emplacement_params)
      flash[:notice] = "emplacement \"#{@emplacement.nom}\" modifié."
    else
      flash[:error] = @emplacement.errors.full_messages.join(',')
    end
    redirect_to emplacements_path
  end

  # DELETE /emplacements/1
  # DELETE /emplacements/1.json
  def destroy
    @emplacement.livres.each do |livre|
      livre.emplacement_id = nil
      livre.save
    end
    @emplacement.destroy
    respond_to do |format|
      format.html { redirect_to emplacements_url, notice: 'Emplacement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emplacement
      @emplacement = Emplacement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def emplacement_params
      params.require(:emplacement).permit(:nom)
    end
end
