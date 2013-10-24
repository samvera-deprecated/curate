#require Hydra::Collections::Engine.root + '/app/helpers/collections_helper.rb'
# View Helpers for Hydra Collections functionality
module Curate::CollectionsHelper 
  
  # Displays the Collections create collection button.
  def button_for_create_new_collection(label = 'Create Collection')
    render partial: 'button_create_collection', locals:{label:label}
  end

  def title_for_new_form(profile_section)
    profile_section == 'true' ? 'Add a Section to my Profile' : 'Create a New Collection'
  end

  def can_edit_profile_collection?(person)
    person.profile && can?(:edit, person.profile)
  end

  def hidden_collection_members
    _erbout = ''
    if params[:batch_document_ids].present?
      params[:batch_document_ids].each do |batch_item|
        _erbout.concat hidden_field_tag("batch_document_ids[]", batch_item)
      end
    end
    _erbout.html_safe
  end

  def has_any_collections?
    current_user.collections.count > 0 if current_user
  end

  def list_items_in_collection(collection, terminate=false)
    content_tag :ul do
      collection.members.inject('') do |output, member|
        output << member_line_item(collection, member, terminate)
      end.html_safe
    end
  end

  def member_line_item(collection, member, terminate)
    content_tag :li do
      data = member.respond_to?(:members) ? collection_line_item(member, terminate) : work_line_item(member)
      data << remove_line_item(collection, member)
    end
  end

  def work_line_item(work)
    link = link_to work.to_s, polymorphic_path_for_asset(work)
    link + ' ' + contributors(work)
  end

  def collection_line_item(collection, terminate)
    list_item = link_to(collection.to_s, collection_path(collection))
    list_item << list_items_in_collection(collection, true) unless terminate  # limit nesting
    list_item
  end

  def contributors(work)
    if work.respond_to?(:contributors)
      "(#{work.contributors.to_a.join(', ')})"
    else
      ''
    end
  end

  def remove_line_item(collection, work)
    link_to(raw('<i class="icon-white icon-minus"></i>'), remove_member_collections_path(id: collection.to_param, item_id: work.pid), id: work.pid, class: 'btn btn-danger remove', title: 'Remove Item from Collection' ) if can? :edit, work 
  end

end

