module Jekyll
  class PortfolioTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)

      source_dir = context.registers[:site].source
      directory_files = File.join(source_dir, '/portfolio/', "*")

      # Load the templates
      templates = []
      exclude = Regexp.new('index.html$', Regexp::EXTENDED | Regexp::IGNORECASE)
      files = Dir.glob(directory_files).reject{|f| f =~ exclude }
      files.each do |filename|
        templates << YAML.load_file(filename)
      end

      # Sort the templates
      templates.sort! {|x, y| x['order'] <=> y['order']}

      # Build the result
      result = ''
      templates.each do |template|
        result << "
        <li>
          <a href=\".html\">
            <img src=\"#{template['portfolio_preview']}\" alt=\"\" />
            <div class=\"caption\">
              <div>
                <h4>#{template['title']}</h4>
                <span>#{template['subtitle']}</span>
              </div>
            </div>
          </a>
        </li>
        "
      end
      result
    end
  end
end

Liquid::Template.register_tag('portfolio', Jekyll::PortfolioTag)