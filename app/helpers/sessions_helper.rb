module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end


  def remember(user)
    user.remember
    cookies.signed[:remember_token] = { value: user.remember_token, expires: 1.year.from_now.utc }
    cookies.signed[:user_id] = { value: user.id, expires: 1.year.from_now.utc }
  end


  def forget(user)
    user.forget if user.present?
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  def log_out
    forget(@current_user)
    session.delete(:user_id)
    @current_user = nil
  end


  # get the currently logged in user
  def current_user
    if session[:user_id]
      # retrieve the current user from the DB on first invocation, then from memory
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies.signed[:remember_token])
        log_in user
        @current_user = user
      end
    else
      # clear the current_user to avoid discontinuity if cookies are purged, etc.
      log_out
    end
  end


  def logged_in?
    current_user.present?
  end
end
