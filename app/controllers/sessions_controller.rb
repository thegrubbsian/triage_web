class SessionsController < ApplicationController

  def create
    @user = User::Authenticator.authenticate(params[:email], params[:password])
    if @user
      render json: @user
    else
      render_errors(403, { invalid_sign_in: "Could not authenticate." });
    end
  end

end
