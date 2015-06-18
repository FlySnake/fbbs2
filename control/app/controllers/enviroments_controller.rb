class EnviromentsController < BaseAdminController
  before_filter :set_enviroment, only: [:show, :edit, :update, :destroy]
  before_filter :set_repositories, only: [:new, :edit, :create]
  before_filter :set_base_versions, only: [:new, :edit, :create]
  before_filter :set_issue_trackers, only: [:new, :edit, :create]
  before_filter :set_tests_executors, only: [:new, :edit, :create]
  before_filter :set_target_platforms, only: [:new, :edit, :create]

  # GET /enviroments
  # GET /enviroments.json
  def index
    @enviroments = Enviroment.all
  end

  # GET /enviroments/1
  # GET /enviroments/1.json
  def show
  end

  # GET /enviroments/new
  def new
    @enviroment = Enviroment.new
  end

  # GET /enviroments/1/edit
  def edit
  end

  # POST /enviroments
  # POST /enviroments.json
  def create
    @enviroment = Enviroment.new(enviroment_params)

    respond_to do |format|
      if @enviroment.save
        format.html { redirect_to @enviroment, notice: 'Enviroment was successfully created.' }
        format.json { render :show, status: :created, location: @enviroment }
      else
        format.html { render :new }
        format.json { render json: @enviroment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enviroments/1
  # PATCH/PUT /enviroments/1.json
  def update
    respond_to do |format|
      if @enviroment.update(enviroment_params)
        format.html { redirect_to @enviroment, notice: 'Enviroment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enviroment }
      else
        format.html { render :edit }
        format.json { render json: @enviroment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enviroments/1
  # DELETE /enviroments/1.json
  def destroy
    @enviroment.destroy
    respond_to do |format|
      format.html { redirect_to enviroments_url, notice: 'Enviroment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enviroment
      @enviroment = Enviroment.find(params[:id])
    end

    def set_repositories
      @repositories = Repository.all
    end

    def set_base_versions
      @base_versions = BaseVersion.order(:name => :asc).all
    end

    def set_issue_trackers
      @issue_trackers = IssueTracker.all
    end

    def set_target_platforms
      @target_platforms = TargetPlatform.all_ordered_by_mask @enviroment.target_platforms_order
    end

    def set_tests_executors
      @tests_executors = TestsExecutor.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enviroment_params
      p = params.require(:enviroment).permit(:title, :default_build_number, :repository_id, :branches_filter, :issue_tracker_id,
                                             :target_platforms_order, :tests_executor_id, :tests_enabled_by_default,
                                             :delete_build_jobs_older_than, :base_version_ids => [])
      p[:target_platforms_order] = JSON.parse p[:target_platforms_order]
      p
    end

end
