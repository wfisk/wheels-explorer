/*****************************************************************
app_models.js

app.models.AppModel
app.collections.AppModels
app.controllers.AppModels
app.views.appModels.edit
app.views.appModels.index
app.views.appModels.notice


*****************************************************************/


/*----------------------------------------------------------------
app.models.AppModel
----------------------------------------------------------------*/
app.models.AppModel = Backbone.Model.extend({

});


/*----------------------------------------------------------------
app.collections.AppModels
----------------------------------------------------------------*/
app.collections.AppModels = Backbone.Collection.extend({
    model: app.models.AppModel,
    url: '/code4wheels/index.cfm?controller=wheels-explorer&action=models&format=json',
    url2: function() {
      //var base = 'documents';
      //if (this.isNew()) return base;
      //return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
      var base = app.path.models;
      
      return base;
      
    }   
});


/*----------------------------------------------------------------
app.controllers.AppModels
----------------------------------------------------------------*/
app.controllers.AppModels = Backbone.Controller.extend({
  routes: {
    "argh":                     "argh",
    "documents/:id":            "edit",
    "":                         "index",
    "new":                      "newDoc"
  },


  argh: function() {
    $("#notice").text("Hello Argh");
    
    
  },
    
    

    
  edit: function(id) {
    var doc = new app.models.AppModel({ id: id });
    doc.fetch({
      success: function(model, resp) {
        new app.views.appModels.Edit({ model: doc });
      },
      
      error: function() {
        new Error({ message: 'Could not find that document.' });
        window.location.hash = '#';
      }
    });
  },
    
    
  index: function() {
    var appModels = new app.collections.AppModels();

    appModels.fetch({
      success: function() {
        new app.views.appModels.Index({ collection: appModels });
      },
      
      error: function() {
        new Error({ message: "Error loading documents." });
      }
    });
  },

    
  newDoc: function() {
    new app.views.appModels.Edit({ model: new app.models.AppModel() });
  }
});


/*----------------------------------------------------------------
app.views.appModels
----------------------------------------------------------------*/
app.views.appModels = {}

app.views.appModels.Edit = Backbone.View.extend({
    events: {
        "submit form": "save"
    },
    
    initialize: function() {
        _.bindAll(this, 'render');
        this.model.bind('change', this.render);
        this.render();
    },
    
    render: function() {
        $(this.el).html(JST.document({ model: this.model }));
        $('#app').html(this.el);
        
        // use val to fill in title, for security reasons
        this.$('[name=title]').val(this.model.get('title'));
        
        this.delegateEvents();
    },
    
    
    save: function() {
        var self = this;
        var msg = this.model.isNew() ? 'Successfully created!' : "Saved!";
        
        this.model.save({ title: this.$('[name=title]').val(), body: this.$('[name=body]').val() }, {
            success: function(model, resp) {
                new App.Views.Notice({ message: msg });
                Backbone.history.saveLocation('documents/' + model.id);
            },
            error: function() {
                new App.Views.Error();
            }
        });
        
        return false;
    }
    
    
});



app.views.appModels.Index = Backbone.View.extend({
    initialize: function() {
        this.appModels = this.collection;
        this.render();
    },
    
    render: function() {
      $('#app').html( "documents: " + this.appModels.length  );
      
      $("#sideMenu").empty();
      $("#sideMenuTemplate").tmpl( this.appModels.toJSON() ).appendTo( "#sideMenu" );
      
      
    }
});


app.views.appModels.Notice = Backbone.View.extend({
    className: "success",
    displayLength: 5000,
    defaultMessage: '',
    
    initialize: function() {
        _.bindAll(this, 'render');
        this.message = this.options.message || this.defaultMessage;
        this.render();
    },
    
    render: function() {
        var view = this;
        
        $(this.el).html(this.message);
        $(this.el).hide();
        $('#notice').html(this.el);
        $(this.el).slideDown();
        $.doTimeout(this.displayLength, function() {
            $(view.el).slideUp();
            $.doTimeout(2000, function() {
                view.remove();
            });
        });
        
        return this;
    }
});


app.views.appModels.Error = app.views.appModels.Notice.extend({
    className:      "error",
    defaultMessage: 'Uh oh! Something went wrong. Please try again.'
});

