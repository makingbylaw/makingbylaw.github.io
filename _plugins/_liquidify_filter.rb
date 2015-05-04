module LiquidifyFilter
  def liquidify(input)
    template = Liquid::Template.parse(input)
    template.render
  end
end

Liquid::Template.register_filter(LiquidifyFilter)