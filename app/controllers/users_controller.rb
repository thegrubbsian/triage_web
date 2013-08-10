class UsersController < ApplicationController

  def create
    @user = User::Authenticator.sign_up(params[:user])
    if @user
      render :show
    else
      render_errors(500, { error_creating_user: "Could not create user." })
    end
  end

end
