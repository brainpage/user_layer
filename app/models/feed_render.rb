# Define content render for feed. 
# Supposed to be included by ApplicationHelper

module FeedRender
  
  def render_feed(feed)
    spec = send("xtype_#{feed.xtype}", feed)
    return "" if spec.blank?
    
    c = content_tag(:div, :class => "span2 feed-icon"){image_tag "#{feed.xtype}.png"}  
    c << content_tag(:div, :class => "span10") do
      content_tag(:div, spec[:content].html_safe, :class => "content") +
      content_tag(:div, :class=>"sub"){spec[:sub].html_safe + content_tag(:span, time_ago_in_words(feed.created_at))}
    end
    c.html_safe
  end
  
  def xtype_welcome(feed)
    {
      :content => "Welcome to brainpage <br />Be there without being there.",
      :sub => link_to("About Brainpage")
    }
  end
  
  def xtype_add_sensor(feed)
    {
      :content => "You have set up your account successfully. <br />Your data is being collected to help you improve your health.",
      :sub => link_to("Change Settings")
    }
  end
  
  def xtype_join_activity(feed)
    {
      :content => "#{feed.user == feed.referer ? "You" : feed.referer.try(:name)} joined the completion of Use facebook less for charity.",
      :sub => link_to("View Activity", rsi_activity_path(feed.originator))
    }
  end
  
  def xtype_alert_sensor_install(feed)
    return nil if feed.user.sensor_added?
    {
      :content => "You haven't installed client tracking software. You need that to record your activity.",
      :sub => link_to("Download Now")
    }
  end
end