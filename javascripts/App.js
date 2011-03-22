var app = {
  collections: {},
  controllers: {},
  models: {},
  views: {},
    
  init: function() {
    new app.controllers.AppModels();
    Backbone.history.start();
  }
};
