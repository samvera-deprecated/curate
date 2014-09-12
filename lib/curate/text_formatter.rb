require 'rdiscount'
require 'sanitize'

module Curate
  module TextFormatter
    module_function
    def call(text: nil)
      markdown = RDiscount.new(text, :autolink, :smart)
      html = markdown.to_html
      Sanitize.fragment(html, Sanitize::Config::RELAXED)
    end
  end
end
