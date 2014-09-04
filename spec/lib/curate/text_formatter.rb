require 'spec_helper'

module Curate
  describe TextFormatter do
    describe '#call' do
      subject { described_class }

      # The text formatting tests are only to verify the presence of basic
      # formatting syntax. We will not test markdown in its entirety.

      it 'allows single newlines in a paragraph' do
        text = <<-eos.gsub(/^ {10}/, '')
          If there is a single line break between blocks of text (leaving no
          empty whitespace between the text blocks) the contents of both blocks
          of text should be combined into a single paragraph tag.
          This text should NOT be in second paragraph tag.
        eos
        expect(subject.call(text: text)).to have_tag('p', count: 1)
      end

      it 'separates paragraphs with two line breaks' do
        text = <<-eos.gsub(/^ {10}/, '')
          If there are TWO line breaks between blocks of text (leaving a single
          empty line between those text blocks) each block should be turned into
          a "p" tag.

          This text should be in second paragraph tag.
        eos
        expect(subject.call(text: text)).to have_tag('p', count: 2)
      end

      it 'makes words surrounded by single pairs italic' do
        text = <<-eos.gsub(/^ {10}/, '')
            If text is surrounded by a pair of *asterisks* or _underscores_ it
            will be _italic_.
        eos
        expect(subject.call(text: text)).to have_tag('em', count: 3)
      end

      it 'makes words surrounded by double pairs bold' do
        text = <<-eos.gsub(/^ {10}/, '')
            If text is surrounded by a TWO pairs of **asterisks** or
            __underscores__ it will be **bold**
        eos
        expect(subject.call(text: text)).to have_tag('strong', count: 3)
      end

      it 'makes quotes curly intelligently' do
        text = <<-eos.gsub(/^ {10}/, '')
            Text that is "quoted" shouldn't be surrounded by double primes.
            It should use proper “curly” qotes instead.
        eos
        expect(subject.call(text: text)).to_not match(/"/)
        expect(subject.call(text: text)).to_not match(/'/)
      end
    end

    context 'Link creation' do
      it 'captures a full URL' do
        text = <<-eos.gsub(/^ {10}/, '')
          If I include a fully-qualified URL like this one: http://www.nd.edu
          there should be a link element with the "href" attribute set to the
          value of the URL literal.
        eos
        expect(subject.call(text: text)).to have_tag('a', with: { href: 'http://www.nd.edu'})
      end

      it 'captures a partial URL' do
        text = <<-eos.gsub(/^ {10}/, '')
          If I include a URL fragment like this one: google.com there should
          be a link element with the "src" attribute set to the inferred
          value of the URL.
        eos
        pending('not supported by the Rdiscount autolink extension')
        expect(subject.call(text: text)).to have_tag('a', with: { href: 'http://google.com'})
      end
    end

    context 'Sanitizing HTML output' do
      it 'removes script tags' do
        text = <<-eos.gsub(/^ {10}/, '')
          A malicious user could try to inject JavaScript directly into the
          HTML via a script tag. <script>alert('Like this');</script>
        eos
        expect(subject.call(text: text)).to_not have_tag('script')
      end

      it 'removes JavaScript links' do
        text = <<-eos.gsub(/^ {10}/, '')
          JavaScript can also be included in an anchor tag
          <a href="javascript:alert('CLICK HIJACK');">like so</a>
        eos
        expect(subject.call(text: text)).to_not have_tag("a[href]")
      end
    end

  end
end
