App.Collections.Documents = Backbone.Collection.extend({
    model: Doctor,
    url: '/code4wheels/index.cfm?controller=wheels-explorer&action=models&format=json',
    url2: function() {
      //var base = 'documents';
      //if (this.isNew()) return base;
      //return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
      var base = App.path.models;
      
      return base;
      
    }   
});



