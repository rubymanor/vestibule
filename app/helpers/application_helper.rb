require 'redcarpet'
require 'uri'

module ApplicationHelper
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
    if user.twitter_image.present?
      if bigger
        user.twitter_image.gsub(/_normal/, "_reasonably_small")
      else
        user.twitter_image
      end
    else
      size = bigger ? "b" : "n"
      "http://img.tweetimag.es/i/#{user.twitter_nickname}_#{size}"
    end
  end

  def wikiize(text)
		names = {}
    User.all.each {|user| names[user.name] = link_to(user.name, user) }
    Proposal.all.each {|proposal| names[proposal.title] = link_to(proposal.title, proposal) }
		text.gsub!(/\[\[(.+?)\]\]/) {|s| names[$1] || link_to($1, {:controller => "proposals", :action => "new", :title => URI.escape($1)}, :class => "New") }
		text.gsub(/(^|\W)(@(.+?))(\W|$)/) {|s| user = User.find_by_twitter_nickname $3; $1 + (user ? link_to($2, user) : $2) + $4 }
  end

  def markdown(text)
    if text
			text = wikiize(text)
      markdown_parser.render(text).html_safe
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
