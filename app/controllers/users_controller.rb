class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
      Rails.logger.debug(@user.inspect)
      if @user.save
        flash[:success] = 'User was successfully created.'
        redirect_to @user
      else
        @title = "Sign up"
        render action: "new"
      end

  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

end
