$(function() {
  $.widget( "curate.manage_fields", {
    options: {
      change: null,
      add: null,
      remove: null
    },

    _create: function() {
      this.element.addClass("managed");

      this.actions = $("<span class=\"field-actions\">");
      this.remover = $("<button class=\"btn btn-danger remove\"><i class=\"icon-white icon-minus\"></i>Remove</button>");
      this.adder   = $("<button class=\"btn btn-success add\"><i class=\"icon-white icon-plus\"></i>Add</button>");

      $('.field-wrapper', this.element).append(this.actions);
      $('.field-actions', this.element).append(this.remover);
      $('.field-actions:last', this.element).append(this.adder);

      console.log('** Create **');
      this._on( this.element, {
        "click .remove": "remove_from_list",
        "click .add": "add_to_list"
      });
    },

    add_to_list: function( event ) {
      event.preventDefault();
      console.log('** Add **');
      $(event.target)
        .parents('.field-wrapper')
        .clone()
        .appendTo(this.element);
      this._trigger("remove");
    },

    remove_from_list: function( event ) {
      event.preventDefault();
      console.log('** Remove **');
      $(event.target)
        .parents('.field-wrapper')
        .remove();
      this._trigger("add");
    },

    _destroy: function() {
      this.actions.remove();
      this.element.removeClass( "managed" );
    },
  });

  $('.multi_value.control-group').manage_fields();

});
