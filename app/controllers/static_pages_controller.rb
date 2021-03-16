class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.recent_posts.paginate page: params[:page],
                                      per_page: Settings.paginate.per_page
  end

  def help; end
end
