<cfcomponent extends="Wheels" output="false">
<cfscript>
  
  function index() {
    renderPage( 
      layout   = "/../plugins/wheelsexplorer/views/layout.cfm",
      template = "/../plugins/wheelsexplorer/views/wheelsexplorer/index.cfm" );
  }
	
		
</cfscript>
</cfcomponent>