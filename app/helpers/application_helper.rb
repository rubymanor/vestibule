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
    %Q{#{page_title} - #{Settings.event_name}}.html_safe
  end

  def page_title(new_page_title, no_h1 = false)
    content_for :page_title do
      new_page_title
    end
    content_tag :h1, new_page_title unless no_h1
  end

  def remind_account_for_signup_reason
    current_user && !current_user.signup_reason.present? && !request.path[/user/] && can?(:edit, current_user)
  end

  def avatar_url(user, bigger=false)
    hash =
      if user.email.present?
        email_address = user.email.downcase
        Digest::MD5.hexdigest(email_address)
      else
        '00000000000000000000000000000000'
      end

    # `d` parameter is for custom fallback.
    # See https://en.gravatar.com/site/implement/images/ for more info.
    "http://www.gravatar.com/avatar/#{hash}?d=retro"
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

  def proposal_update_information(proposal)
    result = "updated #{time_ago_in_words proposal.updated_at} ago"
    if proposal.suggestions.any?
      suggestion = proposal.suggestions.latest.first
      result += "; latest suggestion #{time_ago_in_words(suggestion.updated_at)} ago"
    end
    result
  end

  def change_proposal_state_button(proposal)
    if proposal.withdrawn? && can?(:republish, proposal)
      link_to "Re-publish proposal", republish_proposal_path(proposal), class: "btn", method: :post
    elsif proposal.published? && can?(:withdraw, proposal)
      link_to "Withdraw proposal", withdraw_proposal_path(proposal), class: "btn btn-danger", method: :post
    end
  end

  def authentication_links(container = :p)
    [['Google', '/auth/google'],
     ['Twitter', '/auth/twitter'],
     ['Github', '/auth/github'],
     ['Facebook', '/auth/facebook']].map { |name, url| content_tag container, link_to(name, url) }.join("\n").html_safe
  end

  protected
  def markdown_parser(options = {})
    @markdown_parser ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                                 {:autolink => true}.merge(options))

  end
end
