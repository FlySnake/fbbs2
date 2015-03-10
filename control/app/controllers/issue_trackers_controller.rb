class IssueTrackersController < BaseAdminController
  before_action :set_issue_tracker, only: [:show, :edit, :update, :destroy]

  # GET /issue_trackers
  # GET /issue_trackers.json
  def index
    @issue_trackers = IssueTracker.all
  end

  # GET /issue_trackers/1
  # GET /issue_trackers/1.json
  def show
  end

  # GET /issue_trackers/new
  def new
    @issue_tracker = IssueTracker.new
  end

  # GET /issue_trackers/1/edit
  def edit
  end

  # POST /issue_trackers
  # POST /issue_trackers.json
  def create
    @issue_tracker = IssueTracker.new(issue_tracker_params)

    respond_to do |format|
      if @issue_tracker.save
        format.html { redirect_to @issue_tracker, notice: 'Issue tracker was successfully created.' }
        format.json { render :show, status: :created, location: @issue_tracker }
      else
        format.html { render :new }
        format.json { render json: @issue_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_trackers/1
  # PATCH/PUT /issue_trackers/1.json
  def update
    respond_to do |format|
      if @issue_tracker.update(issue_tracker_params)
        format.html { redirect_to @issue_tracker, notice: 'Issue tracker was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_tracker }
      else
        format.html { render :edit }
        format.json { render json: @issue_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_trackers/1
  # DELETE /issue_trackers/1.json
  def destroy
    @issue_tracker.destroy
    respond_to do |format|
      format.html { redirect_to issue_trackers_url, notice: 'Issue tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_tracker
      @issue_tracker = IssueTracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_tracker_params
      params.require(:issue_tracker).permit(:title, :weblink, :regex)
    end
end
