<cfcomponent extends="Controller" output="false">
<cfscript>

  function init() {
    provides("html,json,xml");
  }

  
  function index() {
    renderPage( 
      layout   = "/../plugins/wheelsexplorer/views/layout.cfm",
      template = "/../plugins/wheelsexplorer/views/wheelsexplorer/index.cfm" );
  }
  
  
  function controllers() {
    result = $queryFiles( "controllers", "*.cfc", "" );
    
    if ( params.format is "html" ) {
      renderPage( 
        layout   = "../../plugins/wheelsexplorer/views/layout.cfm",
        template = "../../plugins/wheelsexplorer/views/wheelsexplorer/result.cfm" );    
    }
    else {
    }
    renderWith( result );
  }  
  
  
  function models() {
    result = $queryFiles( "models", "*.cfc", "model,wheels" );
    renderWith( result );
  }  

	


  function models2() {
    result = $queryFiles( "models", "*.cfc", "model,wheels" );
    
    if ( params.format is "html" ) {
      renderPage( 
        layout   = "../../plugins/wheelsexplorer/views/layout.cfm",
        template = "../../plugins/wheelsexplorer/views/wheelsexplorer/result.cfm" );    
    }
    else {
      params.format = "json";
    }
    renderWith( result );
  }  

	
	
	function $queryFiles( path, filter, excludes ) {
	  var file = "";
	  var fileCount = 0;
	  var fileIndex = 0;
	  var files = "";
	  var result = ArrayNew(1);
	  
   
    files = $directory( 
      directory = "#application.plugins.wheelsExplorer.dir.root#../../#arguments.path#",
      filter    = arguments.filter );
    
    files = ListToArray( ValueList( files.name ) );
    fileCount = ArrayLen( files );
    for ( fileIndex = 1; fileIndex lte fileCount; fileIndex = fileIndex + 1 ) {
      file = files[ fileIndex ];
      file = REReplaceNoCase( file, "\.cf.$", "" );
      if ( not ListFindNoCase( arguments.excludes, file ) ) {
        ArrayAppend( result, file );
      }  
    }
    
    return result;
	}
	
		
</cfscript>
</cfcomponent>