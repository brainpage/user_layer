# Define content render for feed. 
# Supposed to be included by ApplicationHelper

module FeedRender
  
  def render_feed(feed)
    spec = send("xtype_#{feed.xtype}", feed)
    return "" if spec.blank?
    
    if c = content_tag(:div, :class => "span feed-icon"){image_tag "#{feed.xtype}.png"}  
      c << content_tag(:div, :class => "span") do
        content_tag(:div, spec[:content].html_safe, :class => "content") +
        content_tag(:div, :class=>"sub"){spec[:sub].html_safe + content_tag(:span, time_ago_in_words(feed.created_at) + t(:ago))}
      end      
    end
    c.html_safe
  end
  
  def xtype_welcome(feed)
    {
      :content => t("feed.welcome"),
      :sub => link_to(t(:about))
    }
  end
  
  def xtype_accept_invite(feed)
    {
      :content => t("feed.accept_invite", :name => user_tag(feed.referer)),
      :sub => link_to(t(:see_cloud), rsi_friends_path)
    }
  end
  
  def xtype_friend_request(feed)
    {
      :content => t("feed.friend_request", :name => user_tag(feed.referer)),
      :sub => link_to(t(:accept), rsi_relation_path(feed, :accept => true), :method => :put) +
       link_to(t(:deny), rsi_relation_path(feed), :method => :put)
    }
  end
  
  def xtype_accept_request(feed)
    {:content => t("feed.accept_request", :name => user_tag(feed.referer)),:sub => "" }
  end
  
  def xtype_deny_request(feed)
    {:content => t("feed.deny_request", :name => user_tag(feed.referer)),:sub => ""}
  end
  
  def xtype_add_sensor(feed)
    {
      :content => t("feed.setup"),
      :sub => link_to(t(:change_setting), rsi_settings_path)
    }
  end
  
  def xtype_join_activity(feed)
    #{
    #  :content => "#{feed.user == feed.referer ? "You" : feed.referer.try(:name)} joined the completion of Use facebook less for charity.",
    #  :sub => link_to("View Activity", rsi_activity_path(feed.originator))
    #}
  end

end