# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  SITE_TITLE = "Better Draw a District"
  
  def page_title
    @page_title ? "#{@page_title} | #{SITE_TITLE}" : SITE_TITLE
  end
  
end
