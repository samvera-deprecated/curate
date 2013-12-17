require 'spec_helper'

describe 'curation_concern/generic_files/show.html.erb' do
  it 'displays an audio player' do
    file = stub_model(GenericFile, audit_stat: true, pid: '1234')
    allow(view).to receive(:can?) { true }

    render(template: 'curation_concern/generic_files/show', locals: {curation_concern: file, parent: file})
    
    expect(response).to render_template(partial: '_media_display')
  end
end
