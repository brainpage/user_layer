/**
 * Hover Caption - jQuery plugin to add a simple hover effect
 * and caption to images.
 *
 * Source Code: https://github.com/coryschires/hover-caption
 *
 * Copyright (c) 2011 Cory Schires (coryschires.com)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * Version: 0.2.0
 */


(function($) {

  $.hover_caption = {
    defaults: {
      caption_font_size: '18px',
      caption_color: 'white',
      caption_bold: true,
      caption_default: "Click for screenshots."
    }
  }

    $.fn.extend({
        hover_caption: function(config) {

      var config = $.extend({}, $.hover_caption.defaults, config);

        return this.each(function() {

          var image = $(this);

          // set variable for wrapper div
          var width = image.width();
          var height = image.height();

          //  set caption to title attr if set
          var caption = image.attr('title') ? image.attr('title') : config.caption_default;

          // add necessary html and css
          image
            .css({
              'position': 'relative'
            })
           .wrap('<div>')
           .parent()
            .css({
              'width': width
            })
            .prepend('<h3>'+ caption +'</h3>')
            .find('h3')
            .addClass('hover_caption_caption') // use this hook for additional styling
            .css({
              'width': width - 30,
              'position': 'absolute'
            })
            .hide();

            if (config.caption_bold) { image.css('font-weight', 'bold') };

            // add hover event to toggle message
            image.parent().hover(function() {
              $(this).addClass('hover_caption').find('h3').show();
            }, function() {
              $(this).removeClass('hover_caption').find('h3').hide();
            });

          })
        }
    })

})(jQuery);