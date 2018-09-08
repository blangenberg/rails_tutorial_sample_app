module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # get the currently logged in user
  def current_user
    if session[:user_id]
      # retrieve the current user from the DB on first invocation, then from memory
      @current_user ||= User.find_by(id: session[:user_id])
    else
      # clear the current_user to avoid discontinuity if cookies are purged, etc.
      @current_user = nil
    end
  end

  def logged_in?
    current_user.present?
  end
end
