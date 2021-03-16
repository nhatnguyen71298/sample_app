class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy
  before_action :user_want_to_follow, only: :create

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    flash[:warning] = t "warning.load_relationship"
    redirect_to root_path
  end

  def user_want_to_follow
    @user = User.find_by(id: params[:followed_id])
    return if @user

    flash[:warning] = t "warning.find_by_id"
    redirect_to root_path
  end
end
