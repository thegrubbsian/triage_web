class UsersController < ApplicationController

  def create
    @user = User::Authenticator.sign_up(user_params)
    if @user
      render json: @user
    else
      render_errors(500, { error_creating_user: "Could not create user." })
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
