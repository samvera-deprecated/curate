LICENSING_PERMISSIONS = YAML.load( File.open( Rails.root.join( 'config/licensing_permissions.yml' ) ) ).freeze if File.exist?(Rails.root.join( 'config/licensing_permissions.yml'))
