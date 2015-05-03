module Jekyll
  class PortfolioItemTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @portfolio_page = text.strip! || text
    end

    def render(context)

      title = ""
      subtitle = ""
      preview = ""

      f = File.open("./portfolio/#{@portfolio_page}.md", 'r')
      header_count = 0
      f.each_line do |line| 
        # Detect a header
        if line.start_with?('---')
          header_count = header_count + 1
        end

        # Break out if we've passed the header
        if header_count > 1
          break
        end

        if line.start_with?('title:')
          title = line[6..-1]
        elsif line.start_with?('subtitle:')
          subtitle = line[9..-1]
        elsif line.start_with?('portfolio_preview:')
          preview = line[18..-1]
        end
      end
      f.close

      title = title.strip! || title
      subtitle = subtitle.strip! || subtitle
      preview = preview.strip! || preview

      return "
      <li>
        <a href=\"#{@portfolio_page}.html\">
          <img src=\"#{preview}\" alt=\"\" />
          <div class=\"caption\">
            <div>
              <h4>#{title}</h4>
              <span>#{subtitle}</span>
            </div>
          </div>
        </a>
      </li>
      "
    end
  end
end

Liquid::Template.register_tag('portfolio_item', Jekyll::PortfolioItemTag)