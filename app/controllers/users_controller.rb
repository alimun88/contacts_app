class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show] 
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def my_friends
    @friendships = current_user.friends
  end
  
  def search
    @users = User.search(params[:search_param])
    
    if @users
      @users = current_user.except_current_user(@users)
      render partial: 'friends/lookup'
    else
      render status: :not_found, nothing: true
    end
  end
  
  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)
  
    if current_user.save
      redirect_to my_friends_path, notice: "Friend was successfully added."
    else
      redirect_to my_friends_path, flash[:error] = "There was an error with adding user as friend."
    end
  end
  
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save 
      session[:user_id] = @user.id
      flash[:success] = "Welcome to create own Contacts #{@user.username}"
      #redirect_to user_path(@user)
      redirect_to new_contact_path
    else
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @user.update(user_params) 
      flash[:success] = "You have updated your account Successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def show
    @user_contacts = @user.contacts.paginate(page: params[:page], per_page: 5)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all contacts created by user have been successfully deleted"
    redirect_to users_path
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password)
  end
  
  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end
  
  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admin can perform this action"
      redirect_to root_path
    end
  end
    
end