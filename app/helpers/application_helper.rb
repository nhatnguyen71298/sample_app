module ApplicationHelper
  def full_title page_title = ""
    case I18n.locale
    when :en
      base_title = "Ruby on Rails Tutorial Sample App"
    when :vi
      base_title = "Ứng dụng Rails Mẫu"
    end
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
