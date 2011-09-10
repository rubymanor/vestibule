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
    current_user && !current_user.signup_reason.present? && !request.path[/user/]
  end

  def avatar_url(user)
    size = "n"
    "http://img.tweetimag.es/i/#{user.twitter_nickname}_#{size}"
  end

  def markdown(text)
    if text
      markdown = RDiscount.new(text)
      markdown.to_html.html_safe
    else
      nil
    end
  end

  def proposal_title_for_rss(for_proposal)
    %{"#{h for_proposal.title}" by #{user_name_for_rss(for_proposal.proposer)}}.html_safe
  end

  def suggestion_title_for_rss(for_suggestion)
    %{Suggestion from #{user_name_for_rss(for_suggestion.author)}}.html_safe
  end

  def user_name_for_rss(for_user)
    %{#{h for_user.name} (@#{h for_user.twitter_nickname})}.html_safe
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
end
