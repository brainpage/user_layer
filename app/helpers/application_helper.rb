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
  
  def alert_info(key, content, options = {})
    c = "".html_safe
    unless @js_called
      c << javascript_tag("$(document).ready(function(){$('.alert').alert();$('.alert').bind('closed', function(){$.post('#{hide_rsi_settings_path}', {key: $(this).attr('id')})})});")
      @js_called = true
    end
    return "" if cookies[:hidden_tips].to_s.split(";").include?(key)
    c << content_tag(:div, {:class => "alert fade in", :id=>key}.merge(options)){'<a class="close" data-dismiss="alert" href="#">&times;</a>'.html_safe + content}
  end
  
end
