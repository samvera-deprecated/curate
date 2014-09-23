module GenericFileHelper

  def generic_file_title(gf)
    can?(:read, gf) ? gf.to_s : "File"
  end

  def generic_file_link_name(gf)
    can?(:read, gf) ? gf.filename : "File"
  end

  def alert_class(gf)
    "alert" if gf.with_empty_content?
  end

  def actions_for_edit_button(gf)
    if gf.with_empty_content?
      link_to edit_polymorphic_path([:curation_concern, gf]),{ class: "btn btn-warning", title: "Resolve"}do
        raw('<i class="icon icon-warning-sign icon-white"></i> Resolve')
      end
    else
      link_to 'Edit', edit_polymorphic_path([:curation_concern, gf]),{ class: "btn", title: "Edit #{gf}"}
    end
  end

  def generic_file_characterization(gf)
    if gf.with_empty_content?
      "File Not Found"
    elsif (gf.characterization_terms.values.flatten.map(&:empty?).reduce(true) { |sum, value| sum && value })
      "not yet characterized"
    end
  end

  def rollback_button(gf)
    unless gf.with_empty_content?
      link_to('Rollback', versions_curation_concern_generic_file_path(gf),{ class: 'btn', title: "Rollback to previous version" } )
    end
  end





end
