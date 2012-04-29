module Rsi::ChartsHelper
  def draw_calendar
    c = "".html_safe
    6.downto(0) do |i|
      c << content_tag(:div, i.days.ago.day)
    end
    c
  end
end
