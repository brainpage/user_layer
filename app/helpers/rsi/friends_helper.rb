module Rsi::FriendsHelper
  def show_app_cloud(user, day)
    user.app_usage_stat(day).map do |k, v|
      k = k.split(".").last 
      content_tag(:div, :id => k, :class => "app-cell", :style => "width:#{v * 0.9}%"){content_tag(:span, k)}
    end.join("").html_safe
  end
end
