# Define operations on feed. Call feed.hook_method
# Supposed to be included by ApplicationHelper

module FeedHook
  
  def about_company(feed)
    link_to "About Brainpage"
  end
  
  def change_sensor_setting(feed)
    link_to "Change Settings"
  end
  
end