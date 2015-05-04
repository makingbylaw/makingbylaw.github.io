class SlideshowBlock < Liquid::Block
  def initialize(tag_name, options, tokens)
     super
     a = eval options
     @options = a.first
  end

  def render(context)
    links = super
    links = links.split(/\n/)

    result = '<ul class="slideshow">'
    links.each do |link|
      if !link.strip.empty?
        result << "<li><img src=\"#{link}\" /></li>"
      end
    end
    result << '</ul>'
    result << '<script type="text/javascript">
        $(document).ready(function(){
          
      $(\'.slideshow\').bxSlider({'
    
    generate_pager = false
    use_thumbs = false

    @options.keys.each_with_index do |key, index|

      # Custom keys first
      case key
      when :thumbnails
        if @options[key].to_s == 'scaled'
          generate_pager = true
          use_thumbs = false
        elsif @options[key].to_s == 'thumbed'
          generate_pager = true
          use_thumbs = true
        else
          generate_pager = false
          use_thumbs = false
        end
        if generate_pager
          result << "pagerCustom: 'slideshow-pager'"
        end
      else
        val = @options[key].to_s
        if val != 'true' && val != 'false'
          val = "'#{val}'"
        end
        result << "#{key}: #{val}"
      end
      if index < @options.keys.size - 1
        result << ','
      end
    end

    result << '});
        });
      </script>'
    if generate_pager
      result << '<div id="slideshow-pager">'
      links.each_with_index do |link, index|
        if !link.strip.empty?
          cl = ''
          if use_thumbs
            link = link.gsub('.jpg', '-thumb.jpg').gsub('.png', '-thumb.png')
          else
            cl = 'scaled-thumb'
          end
          result << "<a data-slide-index=\"#{index}\" href=\"\" class=\"#{cl}\"><img src=\"#{link}\" /></a>"
        end
      end
      result << '</div>'
    end
    result
  end
end

Liquid::Template.register_tag('slideshow', SlideshowBlock)