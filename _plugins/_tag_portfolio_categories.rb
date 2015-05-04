module Jekyll
  class PortfolioCategoriesTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)

      # Not the most efficient but it'll work - it's only for generation
      source_dir = context.registers[:site].source
      directory_files = File.join(source_dir, '/portfolio/', "*")

      # Load the templates
      categories = []
      exclude = Regexp.new('index.html$', Regexp::EXTENDED | Regexp::IGNORECASE)
      files = Dir.glob(directory_files).reject{|f| f =~ exclude }
      files.each do |filename|
        template = YAML.load_file(filename)
        categories << template['category']
      end

      # Sort the categories
      categories.sort!
      categories.uniq!

      # Build the result
      result = "
      <div class=\"gallery-nav\">
      <ul>
        <li class=\"current\"><a href=\"#\" data-cat=\"all\" class=\"button\">All</a></li>
      "
      categories.each do |category|

        link = category.downcase.gsub(' ', '-')

        result << "
          <li><a href=\"#\" data-cat=\"#{link}\" class=\"button\">#{ category }</a></li>
        "
      end
      result << "
      </ul>
      </div>
      "
      result
    end
  end
end

Liquid::Template.register_tag('portfolio_categories', Jekyll::PortfolioCategoriesTag)