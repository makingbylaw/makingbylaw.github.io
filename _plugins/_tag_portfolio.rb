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
        template = YAML.load_file(filename)
        template['filename'] = Pathname.new(filename).basename('.md')
        templates << template
      end

      # Sort the templates
      templates.sort! {|x, y| x['order'] <=> y['order']}

      # Build the result
      result = ''
      templates.each do |template|
        #puts template.inspect
        result << "
        <li class=\"#{ template['category'].downcase.gsub(" ", "-") }\">
          <a href=\"/portfolio/#{template['filename']}.html\">
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