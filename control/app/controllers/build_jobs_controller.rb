class BuildJobsController < ApplicationController
  before_filter :set_build_job, only: [:show, :update, :destroy, :stop]
  before_filter :set_enviroment
  before_filter :create_build_job, only: [:new, :enviroments]
  before_filter :set_enviroments
  before_filter :set_build_jobs_ready, only: [:enviroments]
  before_filter :set_build_jobs_active, only: [:enviroments]
  before_filter :check_enviroments
  before_filter :set_variables_for_js, only: [:enviroments]

  # GET /build_jobs
  # GET /build_jobs.json
  def index
    @filterrific = initialize_filterrific(
      BuildJob,
      params[:filterrific],
      select_options: {
        with_branch_id: Branch.options_for_select(@enviroment.branches_filter),
        with_base_version_id: BaseVersion.options_for_select,
        with_target_platform_id: TargetPlatform.options_for_select
      }
    ) or return
    @build_jobs_ready = @filterrific.find.page(params[:page]).per_page(params[:per_page] || 20).
                                     includes(:branch, :commit, :full_version, :target_platform, :build_artefacts, :enviroment).
                                     where(:enviroment => @enviroment, :status => BuildJob.statuses[:ready]).
                                     order(:created_at => :desc)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /build_jobs/1
  # GET /build_jobs/1.json
  def show
  end

  # GET /build_jobs/new
  def new
  end
  
  def enviroments
  end

  # POST /build_jobs
  # POST /build_jobs.json
  def create
    @build_job = BuildJob.new(:branch_id => params[:build_job][:branch], 
                              :base_version_id => params[:build_job][:base_version], 
                              :target_platform_id => params[:build_job][:target_platform], 
                              :notify_user_id => params[:build_job][:notify_user],
                              :started_by_user => current_user,
                              :enviroment => @enviroment,
                              :status => BuildJob.statuses[:fresh],
                              :result => BuildJob.results[:unknown],
                              :comment => params[:build_job][:comment],
                              :generate_build_numbers_url => generate_build_numbers_url(:json))

    respond_to do |format|
      if @build_job.save
        format.html { redirect_to home_enviroments_path, notice: 'Build job was successfully created.' }
        format.json { render :show, status: :created, location: @build_job }
      else
        format.html { render :new }
        format.json { render json: @build_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /build_jobs/1
  # DELETE /build_jobs/1.json
  def destroy
    @build_job.destroy
    respond_to do |format|
      format.html { redirect_to home_enviroments_path, notice: 'Build job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # DELETE /build_jobs/1/stop
  def stop
    respond_to do |format|
      if @build_job.stop!
        format.html { redirect_to home_enviroments_path, notice: 'Build job was successfully stopped.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, flash: {error: 'Error stopping build job.'} }
        format.json { render json: @build_job.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build_job
      @build_job = BuildJob.includes(:enviroment).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_job_params
      params.require(:build_job).permit(:branch, :base_version, :target_platform, :notify_user, :started_by_user, :comment, :status)
    end
    
    def set_enviroment
      @enviroment = Enviroment.includes(:repository).find_by(:title => params[:enviroment_title])
      if @enviroment.nil?
        raise "Unknown build enviroment '#{params[:enviroment_title]}'. Available: #{Enviroment.all.to_a.map{|e| e.title}.join(', ')}"
        # TODO something meaningful like redirect to an error page
      end
      @users = User.order(:email => :asc).all
      @target_platforms = TargetPlatform.all_with_worker
      @branches = Branch.all_filtered(@enviroment.branches_filter)
    end
    
    def set_enviroments
      @enviroments = Enviroment.all.order(:created_at => :asc)
    end
    
    def create_build_job
      @build_job = BuildJob.new(:enviroment => @enviroment)
    end
    
    def set_build_jobs_active
      @build_jobs_active = BuildJob.
          includes(:branch, :commit, :full_version, :target_platform, :build_artefacts, :enviroment).
          where(:status => [BuildJob.statuses[:busy], BuildJob.statuses[:fresh]]).
          order(:created_at => :desc)
    end
          
    def set_build_jobs_ready
      @build_jobs_ready = BuildJob.
          includes(:branch, :commit, :full_version, :target_platform, :build_artefacts, :enviroment).
          where(:enviroment => @enviroment, :status => BuildJob.statuses[:ready]).
          order(:created_at => :desc).
          paginate(:page => params[:page], :per_page => 10)
      
    end
    
    def set_variables_for_js
      gon.build_jobs_live_updates_path = build_jobs_enviroment_live_updates_path(@enviroment.title)
    end
    
    def check_enviroments
      unless @enviroments.any?
        redirect_to enviroments_path, flash: {error: "You have to create at least one build enviroment."}  
      end
    end
    
end
