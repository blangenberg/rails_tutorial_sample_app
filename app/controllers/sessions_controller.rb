class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # valid login
      # create session and redirect to user's show page
      log_in user
      redirect_to user  # equivalent to redirect_to(user_url(user))
    else
      # invalid login
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
  end
end