class BuildNumbersController < ApplicationController
  before_action :set_build_number, only: [:show]
  skip_before_filter :verify_authenticity_token, only: [:generate]
  skip_before_filter :authenticate_user!, only: [:generate]

  # GET /build_numbers
  # GET /build_numbers.json
  def index
    @build_numbers = BuildNumber.includes(:enviroment).all.paginate(:page => params[:page], :per_page => 50).to_a
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
  
  # POST /build_numbers/generate
  # POST /build_numbers/generate.json
  def generate
    env = Enviroment.find(params[:enviroment_id])
    existing = BuildNumber.where(:branch => params[:branch], :commit => params[:vcscommit], :enviroment => env).order(:number => :desc)
    
    if existing.any? # something found - return existing buildnum
      @build_number = existing.first
    else
      existing_for_branch = BuildNumber.where(:branch => params[:branch], :enviroment => env).order(:number => :desc)
      if existing_for_branch.any?
        num = existing_for_branch.first.number
      else
        num = env.default_build_number
      end
      @build_number = BuildNumber.new(:branch => params[:branch], :commit => params[:vcscommit], :enviroment => env, :number => num + 1)
    end
    
    respond_to do |format|
      if not @build_number.changed? or @build_number.save
        format.html { redirect_to build_number, notice: 'Build number was successfully updated.' }
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

end
