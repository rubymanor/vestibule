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
end
