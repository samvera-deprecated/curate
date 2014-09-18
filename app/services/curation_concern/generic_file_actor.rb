module CurationConcern
  class GenericFileActor < CurationConcern::BaseActor

    def create
      super { update_file  && download_create_cloud_resources }
    end

    def update
      super { update_file  && download_create_cloud_resources }
    end

    def rollback
      update_version
    end

    def cloud_resources
      @cloud_resources ||= Array(@cloud_resources).flatten.compact
    end

    def download_create_cloud_resources
      cloud_resources.all? do |resource|
        update_cloud_resource(resource)
      end
    end

    protected
    def update_file
      file = attributes.delete(:file)
      title = attributes[:title]
      title ||= file.original_filename if file
      curation_concern.label = title
      if file
        CurationConcern.attach_file(curation_concern, user, file)
      else
        true
      end
    end

    def update_version
      version_to_revert = attributes.delete(:version)
      return true if version_to_revert.blank?
      return true if version_to_revert.to_s ==  curation_concern.current_version_id

      revision = curation_concern.content.get_version(version_to_revert)
      mime_type = revision.mimeType.empty? ? "application/octet-stream" : revision.mimeType
      options = { label: revision.label, mimeType: mime_type, dsid: 'content' }
      curation_concern.add_file_datastream(revision.content, options)
      curation_concern.record_version_committer(user)
      curation_concern.save
    end

    def update_cloud_resource(cloud_resource)
      return true if ! cloud_resource.present?
      file_path=cloud_resource.download_content_from_host
      if file_path.present? && File.exists?(file_path) && !File.zero?(file_path)
        cloud_resource = File.open(file_path)
        title = attributes[:title]
        title ||= File.basename(cloud_resource)
        curation_concern.label=title
        CurationConcern.attach_file(curation_concern, user, cloud_resource,File.basename(cloud_resource))
        File.delete(cloud_resource)
      end
    rescue ActiveFedora::RecordInvalid
      false
    end
  end
end
