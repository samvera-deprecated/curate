// This widget manages the adding and removing of repeating fields.
// There are a lot of assumptions about the structure of the classes and elements.
// These assumptions are reflected in the MultiValueInput class.

$(function() {
  $.widget( "curate.manage_fields", {
    options: {
      change: null,
      add: null,
      remove: null
    },

    _create: function() {
      this.element.addClass("managed");
      $('.field-wrapper', this.element).addClass("input-append");

      this.controls = $("<span class=\"field-controls\">");
      this.remover  = $("<button class=\"btn btn-danger remove\"><i class=\"icon-white icon-minus\"></i><span>Remove</span></button>");
      this.adder    = $("<button class=\"btn btn-success add\"><i class=\"icon-white icon-plus\"></i><span>Add</span></button>");

      $('.field-wrapper', this.element).append(this.controls);
      $('.field-controls', this.element).append(this.remover);
      $('.field-controls:last', this.element).append(this.adder);

      this._on( this.element, {
        "click .remove": "remove_from_list",
        "click .add": "add_to_list"
      });
    },

    add_to_list: function( event ) {
      event.preventDefault();

      var $activeField = $(event.target).parents('.field-wrapper'),
          $newField = $activeField.clone(),
          $listing = $('.listing', this.element);

      $('.add', $activeField).remove();
      $newField.children('input').val('');
      $listing.append($newField);

      this._trigger("remove");
    },

    remove_from_list: function( event ) {
      event.preventDefault();

      var $activeField = $(event.target).parents('.field-wrapper'),
          activeField = $activeField.element,
          $lastField = $('.field-wrapper:last', this.element),
          lastField = $lastField.element;

      $activeField.remove();

      if (activeField === lastField){
        $('.field-wrapper:last .field-controls', this.element).append(this.adder);
      }

      this._trigger("add");
    },

    _destroy: function() {
      this.actions.remove();
      $('.field-wrapper', this.element).removeClass("input-append");
      this.element.removeClass( "managed" );
    },
  });

  $('.multi_value.control-group').manage_fields();

});
