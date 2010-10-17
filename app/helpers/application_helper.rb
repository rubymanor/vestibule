module ApplicationHelper
  def render_page_title
    %Q{#{content_for(:page_title) || 'Welcome'} :: Vestibule}
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
end
