module ApplicationHelper
  include FeedRender
  
  def li_for(*cnames, &block)
    content_tag(:li, :class => [cnames].flatten.include?(controller_name) ? "active" : nil){block.call}
  end
  
  def download_rsi_client
    content_tag(:div, :class => "alert alert-error f10"){
      "You need to install client application to view your analysis. ".html_safe +
      link_to("Download Now", "/")
    }
  end
end
