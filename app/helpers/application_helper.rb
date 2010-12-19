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

  def output_extra_detail_providers(for_talk)
    output_users(for_talk, :extra_detail_providers)
  end

  def output_discussers(for_talk)
    output_users(for_talk, :discussers)
  end

  def output_users(for_talk, of_kind)
    return if for_talk.send(of_kind).empty?
    content_tag :ul, :class => 'users' do
      providers = for_talk.send(of_kind).map do |edp|
        content_tag :li, edp.email, :class => "user"
      end.join
    end
  end
end
