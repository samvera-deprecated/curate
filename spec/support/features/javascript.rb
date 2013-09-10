module Features
  module Javascript
    def with_javascript?
      @example.metadata[:js] || @example.metadata[:javascript]
    end
  end
end
