class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "warning.find_by_id"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t("warning.log_in_succes", user_name: @user.name)
      redirect_to static_pages_help_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end
end
