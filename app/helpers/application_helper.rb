module ApplicationHelper
  include FeedRender
  
  def li_for(*cnames, &block)
    content_tag(:li, :class => [cnames].flatten.include?(controller_name) ? "active" : nil){block.call}
  end
  
  def download_rsi_client
    content_tag(:div, :class => "alert alert-error f10") do
      t(:alert).html_safe +
      link_to(t(:download), "#", :onclick => "$('#wizard-step').modal('show')")
    end
  end
  
  def user_tag(user)
    return "" if user.blank?
    (user.image.blank? ? "".html_safe : image_tag(user.image)) + user.display_name
  end
end
