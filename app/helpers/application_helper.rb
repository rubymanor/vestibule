require 'redcarpet'
require 'digest/md5'

module ApplicationHelper
  def body_class
    params[:controller]
  end

  def active_nav?(*path_fragments)
    path_fragments.any? { |pf| request.fullpath =~ /\A#{Regexp.escape(pf)}/ }
  end

  def active_nav_class(*path_fragments)
    %{ class="active"}.html_safe if active_nav?(*path_fragments)
  end

  def render_page_title
    page_title = content_for(:page_title)
    page_title = 'Welcome' if page_title.blank?
    # using content_for to set :page_title means it's already been escaped.
    %Q{#{page_title} :: Vestibule}.html_safe
  end

  def page_title(new_page_title, no_h1 = false)
    content_for :page_title do
      new_page_title
    end
    content_tag :h1, new_page_title unless no_h1
  end

  def remind_account_for_signup_reason
    current_user && !current_user.signup_reason.present? && !request.path[/user/]
  end

  def avatar_url(user, bigger=false)
    hash =
      if user.email.present?
        email_address = user.email.downcase
        Digest::MD5.hexdigest(email_address)
      else
        '0'
      end
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def markdown(text)
    if text
      markdown_parser.render(text).html_safe
    else
      ''
    end
  end

  def proposal_title_for_rss(for_proposal)
    %{"#{h for_proposal.title}"}.html_safe
  end

  def suggestion_title_for_rss(for_suggestion)
    if for_suggestion.author == for_suggestion.proposal.proposer
      %{Suggestion from the proposer}
    else
      %{Suggestion from #{user_name_for_rss(for_suggestion.author)}}.html_safe
    end
  end

  def user_name_for_rss(for_user)
    %{#{h for_user.name} (@#{h for_user.github_nickname})}.html_safe
  end

  def user_name(start_sentence = true)
    if @user == current_user
      if start_sentence
        "You"
      else
        "you"
      end
    else
      @user.name
    end
  end

  def possessive(start_sentence = true)
    if @user == current_user
      if start_sentence
        "Your"
      else
        "your"
      end
    else
      "#{@user.name}'#{@user.name.last == 's' ? '' : 's' }"
    end
  end

  def to_have(start_sentence = true)
    %{#{user_name(start_sentence)} #{@user == current_user ? 'have' : 'has'}}
  end

  def to_be(start_sentence = true)
    %{#{user_name(start_sentence)} #{@user == current_user ? 'are' : 'is'}}
  end

  def proposal_div(proposal, &block)
    class_name = "proposal"
    class_name += " withdrawn" if proposal.withdrawn?
    content_tag(:div, :class => class_name, &block)
  end

  protected
  def markdown_parser(options = {})
    @markdown_parser ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                                 {:autolink => true}.merge(options))

  end
end
