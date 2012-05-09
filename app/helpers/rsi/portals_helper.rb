module Rsi::PortalsHelper
  def more_link(part)
    link_to image_tag("arrow.png"),"/info##{part}", :class=>"arrow"
  end
  
  def login_link
    t(:already).html_safe + link_to(t(:login), "#", :onclick => "$('#login-form').modal('show');")
  end
  
  def reg_link
    link_to t(:or).html_safe + t(:create_account).html_safe, "#", :onclick => "$('#reg-form').modal('show');"
  end
end
