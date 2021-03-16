module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: Settings.avatar.size_show}
    gravatar_id = Digest:: MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def form_follow_user
    current_user.active_relationships.build
  end

  def form_unfollow_user
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
