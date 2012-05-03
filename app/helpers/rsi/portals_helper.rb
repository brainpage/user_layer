module Rsi::PortalsHelper
  def more_link(part)
    link_to image_tag("arrow.png"),"/info##{part}", :class=>"arrow"
  end
end
