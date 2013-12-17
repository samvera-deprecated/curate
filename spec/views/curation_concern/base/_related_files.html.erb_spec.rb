require 'spec_helper.rb'

describe 'curation_concern/base/_related_files.html.erb' do
  it 'displays a donload button' do
    file = stub_model(GenericFile, audit_stat: true, pid: '1234')
    work = stub_model(GenericWork, pid: '5678')
    work.generic_files += [file]
    allow(view).to receive(:can?) { true }

    render partial: 'curation_concern/base/related_files',
      locals: {curation_concern: work, with_actions: true}
    
    expect(rendered).to include(download_path(file.noid))
  end
end

