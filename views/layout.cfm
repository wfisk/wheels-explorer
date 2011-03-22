<!DOCTYPE html>
<cfoutput>
<html class="no-js" lang="en">
  <head>
    #styleSheetLinkTag( "../plugins/wheelsexplorer/stylesheets/wheelsexplorer" )#
    
    <!--- script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script --->
    #javascriptIncludeTag( "../plugins/wheelsexplorer/javascripts/jquery-1.5.1" )#
    
    <script src="http://ajax.microsoft.com/ajax/jquery.templates/beta1/jquery.tmpl.min.js"></script>
    <script src="http://ajax.cdnjs.com/ajax/libs/json2/20110223/json2.js"></script>
    <script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.4/underscore-min.js"></script>
    <!--- script src="http://ajax.cdnjs.com/ajax/libs/backbone.js/0.3.3/backbone-min.js"></script --->
    
    
    <!--- #javascriptIncludeTag( "http://ajax.cdnjs.com/ajax/libs/modernizr/1.7/modernizr-1.7.min.js" )# --->
    
    #javascriptIncludeTag( "../plugins/wheelsexplorer/javascripts/backbone" )#

    #javascriptIncludeTag( "../plugins/wheelsexplorer/javascripts/App.js" )#

    #javascriptIncludeTag( "../plugins/wheelsexplorer/javascripts/backbones/app_models" )#


  </head>
  <body>
    <header role="banner">
      <nav role="navigation" >
        <ul>
          <li><a href="##controllers">Controllers</a></li>  
          <li><a href="##models">Models</a></li>  
          <li><a href="##views">Views</a></li>  
          <li><a href="##functions">Functions</a></li>  
          <li><a href="##plugins">Plugins</a></li>  
        </ul>  
      </nav>
    </header>      
    
    <div role="main">
      #includeContent()#
    </div>
    
    <footer role="contentinfo">
      
    </footer>
  </body>
</html>
</cfoutput>
