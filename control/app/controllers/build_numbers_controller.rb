class BuildNumbersController < ApplicationController
  before_action :set_build_number, only: [:show, :update]

  # GET /build_numbers
  # GET /build_numbers.json
  def index
    @build_numbers = BuildNumber.all
  end

  # GET /build_numbers/1
  # GET /build_numbers/1.json
  def show
  end

  # PATCH/PUT /build_numbers/1
  # PATCH/PUT /build_numbers/1.json
  def update
    respond_to do |format|
      if @build_number.update(build_number_params)
        format.html { redirect_to @build_number, notice: 'Build number was successfully updated.' }
        format.json { render :show, status: :ok, location: @build_number }
      else
        format.html { render :edit }
        format.json { render json: @build_number.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build_number
      @build_number = BuildNumber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_number_params
      params.require(:build_number).permit(:branch, :commit, :number)
    end
end
