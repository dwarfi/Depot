class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :admin_user, only: [:index]

  after_filter :verify_authorized, only: [ :index] 

  def index
    @users = User.all
    authorize @users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to root_path, notice: "User Created" }
        format.json { render :show, status: :created, location: @user }
      else
        flash.now[:error] = AlertsHelper.getErrorAlertMessages(@user)
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to root_path, notice: "Profile Updated" }
        #format.json { render :index, status: :created, location: @user }
      else
        flash.now[:error] = AlertsHelper.getErrorAlertMessages(@user)
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    authorize @user
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def show
    @user
    authorize @user
  end

  private

    # Before Filters

    # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:error] = "You are not allowed to perform this action"
        redirect_to root_path 
      end
    end

    # Sets the current user for edit show update destroy
    def set_user
      @user = User.find(params[:id])
    end

    # Confirms an admin user
    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
