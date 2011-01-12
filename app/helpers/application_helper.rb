require 'gravatar'

module ApplicationHelper
  def render_page_title
    page_title = content_for(:page_title)
    page_title = 'Welcome' if page_title.blank?
    # using content_for to set :page_title means it's already been escaped.
    %Q{#{page_title} :: Vestibule}.html_safe
  end

  def page_title(new_page_title)
    content_for :page_title do
      new_page_title
    end
    content_tag :h1, new_page_title
  end

  def remind_user_for_signup_reason
    current_user && !current_user.account.signup_reason.present? && !request.path[/account/]
  end

  def gravatar_url(for_user)
    Gravatar.gravatar_url(for_user, :size => 50, :default => 'monsterid')
  end
end
