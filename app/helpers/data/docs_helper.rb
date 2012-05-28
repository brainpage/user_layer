module Data::DocsHelper

  def docs_content(&block)
    content_tag(:div, :class => "thumbnail") do
      content_tag(:div, :class => "row-fluid") do
        content_tag(:div, :class => "span3") do
          content_tag(:div, :class => "page-header no-border") do
            content_tag(:div, :class => "pull-right"){link_to "Need help?"} +
            content_tag(:h2, "Develop Guide")
          end + render("nav")
        end +
        content_tag(:div, :class => "span9"){block.call}        
      end
    end
  end

end
