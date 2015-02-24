class UsersController < BaseAdminController
  before_filter :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :check_user_admin, only: [:profile]
  
  # GET /users/profile
  def profile
    @user = current_user
  end
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  #def new
  #  @user = User.new
  #end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  #def create
  #  @user = User.new(user_params)
  #  if @user.save
  #    redirect_to @user, notice: 'User was successfully created.'
  #  else
  #    render action: "new"
  #  end
  #end

  # PUT /users/1
  def update
    #if params[:user][:password].blank?
    #  params[:user].delete(:password)
    #  params[:user].delete(:password_confirmation)
    #end

    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: "User #{@user.email} was successfully deleted."
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:admin)
  end
  
end
