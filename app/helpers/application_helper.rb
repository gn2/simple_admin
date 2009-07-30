module ApplicationHelper
  
  # Set page title
  def page_title(page_title)  
    content_for(:page_title) { page_title }  
  end

end