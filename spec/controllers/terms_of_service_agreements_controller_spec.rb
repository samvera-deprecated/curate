require 'spec_helper'

describe TermsOfServiceAgreementsController do
  describe '#new' do
    it 'renders a form'
  end
  describe '#create' do
    it 'redirects to remember location if agreed'
    it 'flashes a notice if you disagree and renders new'
  end
end
