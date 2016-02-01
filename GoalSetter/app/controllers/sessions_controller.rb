class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_crenditals(
    params[:user][:username],
    params[:user][:password]
    )
    if @user
      login!(@user)
      redirect_to teams_url
    else
      render :new
    end
  end

  def destroy
    log_out
    redirect_to new_session_url
  end
end
