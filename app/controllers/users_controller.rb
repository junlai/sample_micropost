class UsersController < ApplicationController
 
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
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
