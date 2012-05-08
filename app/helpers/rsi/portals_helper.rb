module Rsi::PortalsHelper
  def more_link(part)
    link_to image_tag("arrow.png"),"/info##{part}", :class=>"arrow"
  end
  
  def login_link
    t(:already).html_safe + link_to(t(:login), "#", :onclick => "$('#login-form').modal('show');")
  end
end
