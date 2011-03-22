App.Views.Index = Backbone.View.extend({
    initialize: function() {
        this.documents = this.collection;
        this.render();
    },
    
    render: function() {
      $('#app').html( "documents: " + this.documents.length  );
      
      $("#sideMenu").empty();
      $("#sideMenuTemplate").tmpl( this.documents.toJSON() ).appendTo( "#sideMenu" );
      
      
    }
});

