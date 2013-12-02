require 'spec_helper.rb'

describe 'curation_concern/base/_representative_media.html.erb' do
  it 'displays a donload button' do
    file = stub_model(GenericFile, audit_stat: true, pid: 'curate:foo1')
    work = stub_model(GenericWork, representative: file.pid)
    allow(GenericFile).to receive(:load_instance_from_solr).with(file.pid) { file }

    render partial: 'curation_concern/base/representative_media', locals: {work: work}
    
    expect(response).to render_template(partial: '_media_display')
  end
end


