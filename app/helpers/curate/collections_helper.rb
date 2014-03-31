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

  # 'terminate' indicates whether to drill down and display the content of collections within the given collection
  # (i.e. recurse by calling list_items_in_collection on collections within the given collection).
  #
  # 'options' hash may include the following:
  #   :display_contributors - boolean - Indicates whether to display a list of contributors next to the work/collection title.
  #     Default is true.  When omitted from options hash or present and set to true, the contributors will be listed.
  #     When set to false, the contributors are not listed.
  def list_items_in_collection(collection, terminate=false, options={})
    content_tag :ul, class: 'collection-listing' do
      collection.members.inject('') do |output, member|
        output << member_line_item(collection, member, terminate, options)
      end.html_safe
    end
  end

  def member_line_item(collection, member, terminate, options={})
    content_tag :li, class: line_item_class(collection), data: { noid: member.noid }do
      markup = member.respond_to?(:members) ? collection_line_item(member, terminate, options) : work_line_item(member, options)

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

  def work_line_item(work, options={})
    link = link_to work.to_s, polymorphic_path_for_asset(work)
    link = link + ' ' + contributors(work) if options.fetch(:display_contributors, true)
    link
  end

  def collection_line_item(collection, terminate, options={})
    # A collection listed as a terminal (terminate is true) member of another collection gets a
    # normal-sized (<p>) font versus a collection heading-sized (<h3>) font.
    headertag = terminate ? :p : :h3
    list_item = content_tag headertag, class: 'collection-section-heading' do
      link_to(collection.to_s, collection_path(collection))
    end
    if collection.description.present?
      list_item << content_tag( :div, collection.description, class: 'collection-section-description')
    end
    list_item << list_items_in_collection(collection, true, options) unless terminate  # limit nesting
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

