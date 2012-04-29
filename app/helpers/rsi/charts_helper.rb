module Rsi::ChartsHelper
  def draw_calendar
    c = "".html_safe
    month = nil
    6.downto(0) do |i|
      ti = i.days.ago
      pre = "&nbsp;"
      if ti.month != month
        pre = "#{ti.month}."
        month = ti.month
      end
      
      c << content_tag(:div,  content_tag(:span, pre.html_safe, :class=>"month") + ti.day.to_s, (i == 6 ? {:class => "first"} : {}))
    end
    c
  end
end
