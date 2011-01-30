require 'gravatar'
require 'rdiscount'

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

  def remind_account_for_signup_reason
    current_account && !current_account.user.signup_reason.present? && !request.path[/user/]
  end

  def gravatar_url(for_account)
    Gravatar.gravatar_url(for_account, :size => 50, :default => 'monsterid')
  end

  def markdown(text)
    if text
      markdown = RDiscount.new(text)
      markdown.to_html.html_safe
    else
      nil
    end
  end
end
