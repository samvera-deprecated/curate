module CurationConcern
  class GenericWorkActor < CurationConcern::BaseActor

    def create
      editors = attributes.delete('editors_attributes')
      groups = attributes.delete('editor_groups_attributes')

      assign_pid && super {
        attach_files && create_linked_resources &&
        download_create_cloud_resources && assign_representative &&
        add_depositor_as_editor &&
        add_or_update_editors_and_groups(editors, groups, :create)
      }
    end

    def update
      editors = attributes.delete('editors_attributes')
      groups = attributes.delete('editor_groups_attributes')
      add_or_update_editors_and_groups(editors, groups, :update) &&
        add_to_collections(attributes.delete(:collection_ids)) &&
        super { attach_files && create_linked_resources }
    end

    delegate :visibility_changed?, to: :curation_concern

    protected

    def assign_pid
      curation_concern.inner_object.pid = CurationConcern.mint_a_pid
    end

    def add_or_update_editors_and_groups(editors, groups, action)
      CurationConcern::WorkPermission.create(curation_concern, action, editors,
                                             groups)
    end

    def add_depositor_as_editor
      curation_concern.add_editor(user)
      true
    end

    def files
      return @files if defined?(@files)
      @files = [attributes[:files]].flatten.compact
    end

    def attach_files
      files.all? do |file|
        attach_file(file)
      end
    end

    # The default behavior of active_fedora's has_and_belongs_to_many association,
    # when assigning the id accessor (e.g. collection_ids = ['foo:1']) is to add
    # to new collections, but not remove from old collections.
    # This method ensures it's removed from the old collections.
    def add_to_collections(new_collection_ids)
      return true if new_collection_ids.nil?
      #remove from old collections
      (curation_concern.collection_ids - new_collection_ids).each do |old_id|
        Collection.find(old_id).members.delete(curation_concern)
      end

      #add to new
      curation_concern.collection_ids = new_collection_ids
      true
    end

    def linked_resource_urls
      @linked_resource_urls ||= Array(attributes[:linked_resource_urls]).flatten.compact
    end

    def cloud_resources
      @cloud_resources ||= Array(@cloud_resources).flatten.compact
    end

    def download_create_cloud_resources
      cloud_resources.all? do |resource|
        attach_cloud_resource(resource)
      end
    end
    def create_linked_resources
      linked_resource_urls.all? do |link_resource_url|
        create_linked_resource(link_resource_url)
      end
    end

    def create_linked_resource(link_resource_url)
      return true if ! link_resource_url.present?
      resource = LinkedResource.new.tap do |link|
        link.url = link_resource_url
        link.batch = curation_concern
        link.label = curation_concern.human_readable_type
      end
      Sufia::GenericFile::Actions.create_metadata(resource, user, curation_concern.pid)
      true
    rescue ActiveFedora::RecordInvalid
      false
    end

    def assign_representative
      curation_concern.representative = curation_concern.generic_file_ids.first
      curation_concern.save
    end

    private
    def attach_file(file)
      generic_file = GenericFile.new
      generic_file.file = file
      generic_file.batch = curation_concern
      Sufia::GenericFile::Actions.create_metadata(
        generic_file, user, curation_concern.pid
      )
      generic_file.embargo_release_date = curation_concern.embargo_release_date
      generic_file.visibility = visibility
      CurationConcern.attach_file(generic_file, user, file)
    end

    def attach_cloud_resource(cloud_resource)
      return true if ! cloud_resource.present?
      file_path=cloud_resource.download_content_from_host
      if  valid_file?(file_path)
        cloud_resource = File.open(file_path)
        generic_file = GenericFile.new
        generic_file.file = cloud_resource
        generic_file.batch = curation_concern
        Sufia::GenericFile::Actions.create_metadata(
            generic_file, user, curation_concern.pid
        )
        generic_file.embargo_release_date = curation_concern.embargo_release_date
        generic_file.visibility = visibility
        CurationConcern.attach_file(generic_file, user, cloud_resource,File.basename(cloud_resource))
        File.delete(cloud_resource)
      end
    rescue ActiveFedora::RecordInvalid
      false
    end

    def valid_file?(file_path)
      return file_path.present? && File.exists?(file_path) && !File.zero?(file_path)
    end

  end
end
