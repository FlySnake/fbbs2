class WorkersController < BaseAdminController
  before_filter :set_worker, only: [:show, :edit, :update, :destroy, :request_config]
  
  # GET /workers
  def index
    @workers = WorkersPool::Pool.instance.all
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
      if @worker.errors.messages[:worker_config].nil? or @worker.errors.messages[:worker_config].empty?
        redirect_to @worker, notice: "Worker #{@worker.title} was successfully created with platforms #{@worker.target_platforms.map{|p| p.title}.join(', ')}"
      else
        redirect_to @worker, flash: { warning: "Worker #{@worker.title} was successfully created, but its config could not be retrieved: #{@worker.errors.messages[:worker_config].join(', ')}"}
      end
    else
      render action: "new", flash: {error: "Error updating worker's config: #{@worker.errors.messages[:worker_config].nil? ? "" : @worker.errors.messages[:worker_config].join(', ')}"}
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
      redirect_to @worker, flash: {error: "Error updating worker's config: #{@worker.errors.messages[:worker_config].join(', ')}"}
    end
  end
  
  private
  
  def set_worker
    @worker = WorkersPool::Pool.instance.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def worker_params
    params.require(:worker).permit(:title, :address, :priority)
  end
  
end
