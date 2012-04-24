# Define content render for feed. 
# Supposed to be included by ApplicationHelper

module FeedRender
  
  def render_feed(feed)
    spec = send("xtype_#{feed.xtype}", feed)
    return "" if spec.blank?
    
    if c = content_tag(:div, :class => "span2 feed-icon"){image_tag "#{feed.xtype}.png"}  
      c << content_tag(:div, :class => "span10") do
        content_tag(:div, spec[:content].html_safe, :class => "content") +
        content_tag(:div, :class=>"sub"){spec[:sub].html_safe + content_tag(:span, time_ago_in_words(feed.created_at) + " ago")}
      end      
    end
    c.html_safe
  end
  
  def xtype_welcome(feed)
    {
      :content => "Welcome to brainpage <br />Be there without being there.",
      :sub => link_to("About Brainpage")
    }
  end
  
  def xtype_accept_invite(feed)
    {
      :content => "Your friend #{feed.referer.try(:name)} just accepted your invitation.",
      :sub => link_to("Check Application Cloud", rsi_friends_path)
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

end