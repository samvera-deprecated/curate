$(function() {
  $.widget( "custom.manage_fields", {
    options: {
      onAdd: null,
      onRemove: null
    },
    _create: function() {
      this.element.addClass( "managed" );

      this.remover = $( "<button class=\"btn btn-danger remove\"><i class=\"icon-white icon-minus\"></i>Remove</button>");
      this.adder   = $( "<button class=\"btn btn-success add\"><i class=\"icon-white icon-plus\"></i>Add</button>");

      $('.field-wrapper', this.element).append(this.remover);
      $('.field-wrapper:last', this.element).append(this.adder);

      this._on( this.remover, {
        click: "remove_from_list"
      });

      this._on( this.adder, {
        click: "add_to_list"
      });

      this._refresh();
    },
    // called when created, and later when changing options
    _refresh: function() {
      this._trigger( "change" );
    },

    remove_from_list: function( event ) {
      event.preventDefault();
      console.log("Remover CLICK");
      var $trigger = this._trigger
      console.log($trigger);
    },

    add_to_list: function( event ) {
      event.preventDefault();
      console.log("Adder CLICK");
      var $trigger = this._trigger
      console.log($trigger);
    },
    // events bound via _on are removed automatically
    // revert other modifications here
    _destroy: function() {
      // remove generated elements
      this.remover.remove();
      this.adder.remove();
      this.element
        .removeClass( "managed" );
    },
    // _setOptions is called with a hash of all options that are changing
    // always refresh when changing options
    _setOptions: function() {
      // _super and _superApply handle keeping the right this-context
      this._superApply( arguments );
      this._refresh();
    }
  });

  $('.multi_value.control-group').manage_fields();

});
