class TestsExecutorsController < BaseAdminController
  before_action :set_tests_executor, only: [:show, :edit, :update, :destroy]

  # GET /tests_executors
  # GET /tests_executors.json
  def index
    @tests_executors = TestsExecutor.all
  end

  # GET /tests_executors/1
  # GET /tests_executors/1.json
  def show
  end

  # GET /tests_executors/new
  def new
    @tests_executor = TestsExecutor.new
  end

  # GET /tests_executors/1/edit
  def edit
  end

  # POST /tests_executors
  # POST /tests_executors.json
  def create
    @tests_executor = TestsExecutor.new(tests_executor_params)

    respond_to do |format|
      if @tests_executor.save
        format.html { redirect_to @tests_executor, notice: 'Tests executor was successfully created.' }
        format.json { render :show, status: :created, location: @tests_executor }
      else
        format.html { render :new }
        format.json { render json: @tests_executor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests_executors/1
  # PATCH/PUT /tests_executors/1.json
  def update
    respond_to do |format|
      if @tests_executor.update(tests_executor_params)
        format.html { redirect_to @tests_executor, notice: 'Tests executor was successfully updated.' }
        format.json { render :show, status: :ok, location: @tests_executor }
      else
        format.html { render :edit }
        format.json { render json: @tests_executor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests_executors/1
  # DELETE /tests_executors/1.json
  def destroy
    @tests_executor.destroy
    respond_to do |format|
      format.html { redirect_to tests_executors_url, notice: 'Tests executor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tests_executor
      @tests_executor = TestsExecutor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tests_executor_params
      params.require(:tests_executor).permit(:title, :run_params, :artefact_name)
    end
end
