class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :find_user_on_params, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def edit; end

  def show; end

  def index
    @users = User.ordered_by_name_desc.paginate(page: params[:page],
                                           per_page: Settings.paginate.per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "warning.please_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "warning.edit_succes"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    name_delected = @user.name
    if current_user.admin && @user.destroy
      flash[:success] = t("warning.delete_succes", user_name: name_delected)
    else
      flash[:danger] = t "warning.delete_error"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "warning.please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def find_user_on_params
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "warning.find_by_id"
    redirect_to root_path
  end
end
