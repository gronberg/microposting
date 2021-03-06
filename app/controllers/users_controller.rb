class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
     if signed_in?
       redirect_to root_path
     else
      @user = User.new
     end
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Microposting App!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  # TO-DO: prevent admin from deleting self (cannot access destroy action)
  # checkout http://stackoverflow.com/questions/10907325/rspec-test-for-destroy-if-no-delete-link
  # def destroy
  #   @user = User.find(params[:id]).destroy
  #   unless @user.admin = true
  #     flash[:success] = "User destroyed."
  #     redirect_to users_url
  #   end
  # end
  
  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    # removed in section 10.2.2  
    # def signed_in_user
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_url, notice: "Please sign in."
    #   end
    # end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
