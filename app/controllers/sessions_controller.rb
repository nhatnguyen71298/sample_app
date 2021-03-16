class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:sessions][:email].downcase
    users_logging_authentication
  end

  def users_logging_authentication
    if @user&.authenticate params[:sessions][:password]
      flash[:success] = t("warning.log_in_succes", user_name: @user.name)
      log_in @user
      params[:sessions][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:danger] = t "warning.session_error"
      render :new
    end
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
