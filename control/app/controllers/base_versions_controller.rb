class BaseVersionsController < BaseAdminController
  before_action :set_base_version, only: [:show, :edit, :update, :destroy]

  # GET /base_versions
  # GET /base_versions.json
  def index
    @base_versions = BaseVersion.includes(:enviroments).all
  end

  # GET /base_versions/1
  # GET /base_versions/1.json
  def show
  end

  # GET /base_versions/new
  def new
    @base_version = BaseVersion.new
  end

  # GET /base_versions/1/edit
  def edit
  end

  # POST /base_versions
  # POST /base_versions.json
  def create
    @base_version = BaseVersion.new(base_version_params)

    respond_to do |format|
      if @base_version.save
        format.html { redirect_to @base_version, notice: 'Base version was successfully created.' }
        format.json { render :show, status: :created, location: @base_version }
      else
        format.html { render :new }
        format.json { render json: @base_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /base_versions/1
  # PATCH/PUT /base_versions/1.json
  def update
    respond_to do |format|
      if @base_version.update(base_version_params)
        format.html { redirect_to @base_version, notice: 'Base version was successfully updated.' }
        format.json { render :show, status: :ok, location: @base_version }
      else
        format.html { render :edit }
        format.json { render json: @base_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /base_versions/1
  # DELETE /base_versions/1.json
  def destroy
    @base_version.destroy
    respond_to do |format|
      format.html { redirect_to base_versions_url, notice: 'Base version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_version
      @base_version = BaseVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def base_version_params
      params.require(:base_version).permit(:name)
    end
end
