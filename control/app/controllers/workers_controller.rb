class WorkersController < BaseAdminController
  before_filter :set_worker, only: [:show, :edit, :update, :destroy, :request_config]
  
  # GET /workers
  def index
    @workers = Worker.includes(:target_platforms).all
  end

  # GET /workers/1
  def show
  end

  # GET /workers/new
  def new
    @worker = Worker.new
  end

  # GET /workers/1/edit
  def edit
  end

  # POST /workers
  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      redirect_to @worker, notice: "Worker #{@worker.title} was successfully created."
    else
      render action: "new"
    end
  end

  # PUT /workers/1
  def update
    if @worker.update_attributes(worker_params)
      redirect_to @worker, notice: "Worker #{@worker.title} was successfully updated."
    else
      render action: "edit"
    end
  end

  # DELETE /workers/1
  def destroy
    @worker.destroy
    redirect_to workers_url, notice: "Worker #{@worker.title} was successfully deleted."
  end
  
  # POST /workers/1/request_config
  def request_config
    if @worker.request_config!
      redirect_to @worker, notice: "Worker config updated."
    else
      redirect_to @worker, flash: {error: "Error updating worker's config"}
    end
  end
  
  private
  
  def set_worker
    @worker = Worker.includes(:target_platforms).find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def worker_params
    params.require(:worker).permit(:title, :address)
  end
  
end
