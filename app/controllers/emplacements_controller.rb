class EmplacementsController < ApplicationController
  before_action :set_emplacement, only: [:show, :edit, :update, :destroy]
  before_filter :init

  def init
    @title = "Emplacements"
  end
  
  # GET /emplacements
  # GET /emplacements.json
  def index
    @emplacements = Emplacement.all
  end

  # GET /emplacements/1
  # GET /emplacements/1.json
  def show
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

    respond_to do |format|
      if @emplacement.save
        format.html { redirect_to @emplacement, notice: 'Emplacement was successfully created.' }
        format.json { render :show, status: :created, location: @emplacement }
      else
        format.html { render :new }
        format.json { render json: @emplacement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emplacements/1
  # PATCH/PUT /emplacements/1.json
  def update
    respond_to do |format|
      if @emplacement.update(emplacement_params)
        format.html { redirect_to @emplacement, notice: 'Emplacement was successfully updated.' }
        format.json { render :show, status: :ok, location: @emplacement }
      else
        format.html { render :edit }
        format.json { render json: @emplacement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emplacements/1
  # DELETE /emplacements/1.json
  def destroy
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
      params[:emplacement]
    end
end
