class PasswordResetsController < ApplicationController
  before_action :find_user_by_params_email, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "warning.send_email"
      redirect_to root_path
    else
      flash.now[:danger] = t "warning.find_by_id"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      flash[:warning] = t "warning.password_require"
      render :edit
    elsif @user.update user_params
      flash[:success] = t "warning.change_password_success"
      redirect_to login_url
    else
      render :edit
    end
  end

  private

  def find_user_by_params_email
    @user = User.find_by email: params[:email]
    return if @user

    flash.now[:danger] = t "warning.find_by_id"
    redirect_to password_resets_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "warning.password_expired"
    redirect_to new_password_reset_url
  end
end
