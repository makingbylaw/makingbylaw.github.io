module Jekyll
  class PortfolioButtonsTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      current_page = context.registers[:page]['name']

      # Not the most efficient but it'll work - it's only for generation
      source_dir = context.registers[:site].source
      directory_files = File.join(source_dir, '/portfolio/', "*")

      # Load the templates
      templates = []
      exclude = Regexp.new('index.html$', Regexp::EXTENDED | Regexp::IGNORECASE)
      files = Dir.glob(directory_files).reject{|f| f =~ exclude }
      files.each do |filename|
        template = YAML.load_file(filename)
        template['filename'] = Pathname.new(filename).basename.to_s
        template['url'] = Pathname.new(filename).basename(".md").to_s
        templates << template
      end

      # Sort the templates
      templates.sort! {|x, y| x['order'] <=> y['order']}

      # Build the result
      result = ''
      templates.each_with_index do |template, index|
        if template['filename'] == current_page

          # Get the prev and next page
          if index == 0 
            prev_template = templates.last
            next_template = templates[index + 1]
          elsif index == templates.size - 1
            prev_template = templates[index - 1]
            next_template = templates.first
          else
            prev_template = templates[index - 1]
            next_template = templates[index + 1]
          end 

          result << "
            <a href=\"/portfolio/#{ prev_template['url'] }.html\" class=\"button\">&laquo;#{ prev_template['title'] }</a>
            <a href=\"/portfolio/\" class=\"button\">^^</a>
            <a href=\"/portfolio/#{ next_template['url'] }.html\" class=\"button\">#{ next_template['title'] }&raquo;</a>
          "

        end
      end
      result
    end
  end
end

Liquid::Template.register_tag('portfolio_buttons', Jekyll::PortfolioButtonsTag)