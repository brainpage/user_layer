module Rsi::ChartsHelper
  def draw_calendar
    c = "".html_safe
    month = nil
    6.downto(0) do |i|
      ti = i.days.ago
      pre = content_tag(:span, "&nbsp;".html_safe, :class => "month")
      if ti.month != month
        pre = content_tag(:span, ti.month, :class=>"month")+"-"
        month = ti.month
      end
      
      c << content_tag(:div,  pre + ti.day.to_s, (i == 6 ? {:class => "first"} : {}))
    end
    c
  end
end
