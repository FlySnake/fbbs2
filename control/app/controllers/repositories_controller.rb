class RepositoriesController < BaseAdminController
  before_filter :authenticate_user!
  before_filter :set_repository, only: [:show, :edit, :update, :destroy, :fetch_branches]
  
  # GET /repositories
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  def create
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to @repository, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /repositories/1
  def update
    if @repository.update_attributes(repository_params)
      redirect_to @repository, notice: 'Repository was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  # DELETE /repositories/1
  def destroy
    @repository.destroy
    redirect_to users_url, notice: "User #{@user.email} was successfully deleted."
  end
  
  # POST /repositories/1/fetch_branches
  def fetch_branches
    @repository.branches true
    if @repository.errors.empty?
      redirect_to @repository, notice: 'Branches were successfully updated.'
    else
      redirect_to @repository, flash: {error: "Error fetching remote branches: #{@repository.errors.messages[:branches].join(", ")}."}
    end
  end
  
  private
  
  def set_repository
    @repository = Repository.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def repository_params
    params.require(:repository).permit(:title, :path, :vcs_type)
  end
end
