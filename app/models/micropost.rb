class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content.maximum}
  validates :image, content_type: {in: Settings.micropost.image.in,
                                   message: I18n.t("warning.img_wrong_type")},
                    size: {less_than: 5.megabytes,
                           message: I18n.t("warning.img_over_size")}

  scope :recent_posts, ->{order created_at: :desc}

  delegate :name, to: :user

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end
