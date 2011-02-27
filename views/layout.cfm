<cfoutput>
<html>
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
    <script src="http://ajax.cdnjs.com/ajax/libs/json2/20110223/json2.js"></script>
    <script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.4/underscore-min.js"></script>
    <script src="http://ajax.cdnjs.com/ajax/libs/backbone.js/0.3.3/backbone-min.js"></script>

    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/App.js" )#

    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/collections/app_controllers.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/collections/app_models.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/collections/app_views.js" )#
    
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/controllers/AppControllers.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/controllers/AppModels.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/controllers/AppViews.js" )#
    
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/models/AppController.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/models/AppModel.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/models/AppView.js" )#
    
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_controllers/index.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_controllers/show.js" )#
    
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_models/index.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_models/show.js" )#
    
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_views/index.js" )#
    #javascriptIncludeTag( "/../plugins/wheelsexplorer/javascripts/views/app_views/show.js" )#
  </head>
  <body>
    Something here.
    #includeContent()#
  </body>
</html>
</cfoutput>
