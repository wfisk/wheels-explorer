<cfscript>
  set( showDebugInformation = false );
</cfscript>
<cfoutput>
  <script>
    app.path = {
      controllers: '#urlFor( controller="WheelsExplorer", action="controllers", params="format=json" )#',   
      models:      '#urlFor( controller="WheelsExplorer", action="models",      params="format=json" )#',   
      views:       '#urlFor( controller="WheelsExplorer", action="views",       params="format=json" )#'   
    }
  
    app.baseUrl = #linkTo( controller="WheelsExplorer" )#
  </script>
  
  <aside role="complementary">
    <div role="menu">  
      <ul id="sideMenu">
      </ul>  
    </div>
    <script id="sideMenuTemplate" type="text/x-jquery-tmpl">
        <li><a href="##!argh">${title}</a></li>
    </script>
  </aside>    


  <article role="article">
    <header>
      <h1><a href="##">CloudEdit</a></h1>
      <h2>A Backbone.js Rails Example by <a href="http://www.jamesyu.org/">James Yu</a>. <a href="http://www.jamesyu.org/2011/01/27/cloudedit-a-backbone-js-tutorial-by-example/">Read the tutorial here</a>.</h2>
    </header>
    <div id="notice"></div>

    <div id="app">sss</div>

    <p>Note: Only the last 50 documents are shown.</p>
  </article>
  
  <script>
      $(function() {
          app.init();
      });
  </script>  
</cfoutput>

