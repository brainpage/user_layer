module Rsi::FriendsHelper
  def show_app_cloud(user, day)
    $colors = %w{c1 c2 c3 c4 c5 c6 c7 c8 c9 c10}
    if $color_hash.blank?
      $color_hash = {}
    end
    
    user.app_usage_stat(day).map do |k, v|
      if (color = $color_hash[k]).blank?
        $color_hash[k] = color = $colors[rand(10)]
      end
      content_tag(:div, :class => "b #{color}", :style => "width:#{v}%"){k.split(".").last}
    end.join("").html_safe
  end
end
