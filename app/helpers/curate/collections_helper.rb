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
    content_tag :ul, class: 'collection-listing' do
      collection.members.inject('') do |output, member|
        output << member_line_item(collection, member, terminate)
      end.html_safe
    end
  end

  def member_line_item(collection, member, terminate)
    content_tag :li, class: line_item_class(collection), data: { noid: member.noid }do
      markup = member.respond_to?(:members) ? collection_line_item(member, terminate) : work_line_item(member)

      if can? :edit, collection
        markup << collection_member_actions(collection, member)
      end

      markup
    end
  end

  def line_item_class(collection)
    css_class = 'collection-member'
    css_class << ' with-controls' if can? :edit, collection
    css_class
  end

  def work_line_item(work)
    link = link_to work.to_s, polymorphic_path_for_asset(work)
    link + ' ' + contributors(work)
  end

  def collection_line_item(collection, terminate)
    list_item = content_tag :h3, class: 'collection-section-heading' do
      link_to(collection.to_s, collection_path(collection))
    end
    if collection.description.present?
      list_item << content_tag( :div, collection.description, class: 'collection-section-description')
    end
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

  def collection_member_actions(collection, member)
    content_tag :span, class: 'collection-member-actions' do
      if member.respond_to?(:members)
        markup = actions_for_member(collection, member)
        markup << actions_for_profile_section(collection, member)
      else
        actions_for_member(collection, member)
      end
    end
  end

  # NOTE: Profile Sections and Collections are being rendered the same way.
  def actions_for_profile_section(collection, member)
    if can? :edit, member
      link_to edit_collection_path(id: member.to_param), class: 'btn' do
        raw('<i class="icon-pencil"></i> Edit')
      end
    end
  end

  def actions_for_member(collection, member)
    button_to remove_member_collections_path(id: collection.to_param, item_id: member.pid), data: { confirm: 'Are you sure you want to remove this item from the collection?' }, method: :put, id: "remove-#{member.noid}", class: 'btn btn-danger', form_class: 'remove-member', remote: true do
      raw('<i class="icon-white icon-minus"></i> Remove')
    end
  end

end

