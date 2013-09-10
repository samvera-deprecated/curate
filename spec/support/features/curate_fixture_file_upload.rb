module Features
  module CurateFixtureFileUpload
    def curate_fixture_file_upload(path, content_type = 'text/plain', binary = false)
      normalized_path = File.join(Curate::Engine.root.to_s, 'spec/fixtures', path)
      Rack::Test::UploadedFile.new(normalized_path, content_type, binary)
    end
  end
end
