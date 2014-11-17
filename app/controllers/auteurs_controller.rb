class AuteursController < ApplicationController
  before_action :set_auteur, only: [:show, :edit, :update, :destroy]
  before_filter :init

  def init
    @title = "Auteurs"
  end

  # GET /auteurs
  # GET /auteurs.json
  def index
    @auteurs = Auteur.all
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auteur_params
      params.require(:auteur).permit(:nom)
    end
end
