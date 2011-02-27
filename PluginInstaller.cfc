<cfcomponent output="false">

<!---------------------------------------------------------------------
init
---------------------------------------------------------------------->
<cffunction name="init" output="false">
  <cfargument name="pluginName" type="string" required="true">
  <cfscript>
    $pluginName = arguments.pluginName;
    
    $dir = StructNew();
    $dir.root = GetDirectoryFromPath( GetBaseTemplatePath() );
    $dir.controllers = $dir.root & "/controllers";
    $dir.javascripts = $dir.root & "/javascripts";
    $dir.models      = $dir.root & "/models";
    $dir.plugin      = $dir.root & "/plugins/$pluginName";
    $dir.stylesheets = $dir.root & "/stylesheets";
    $dir.views       = $dir.root & "/views";
    
    $log = ArrayNew(1);
    
    return this;
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
getLog
---------------------------------------------------------------------->
<cffunction name="getLog" output="false" >
  <cfscript>
    return $log;
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
installEmbeddedFiles
---------------------------------------------------------------------->
<cffunction name="installEmbeddedFiles" output="false">
  <cfscript>
    $clearLog();

    $installControllers();
    $installJavascripts();
    $installModels();
    $installStylesheets();
    $installViews();
    
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
removeEmbeddedFiles
---------------------------------------------------------------------->
<cffunction name="removeEmbeddedFiles" output="false">
  <cfscript>
    $clearLog();

    $removeControllers();
    $removeJavascripts();
    $removeModels();
    $removeStylesheets();
    $removeViews();
  
    $logMessage( "" );
  </cfscript>

</cffunction>


<!---------------------------------------------------------------------
PRIVATE METHODS
---------------------------------------------------------------------->




<!---------------------------------------------------------------------
$changeFileExtension
---------------------------------------------------------------------->
<cffunction name="$changeFileExtension" returntype="string"  output="false">
  <cfargument name="filename" type="string" required="true" />
  <cfargument name="newExtension" type="string" required="true" />

  <cfscript>
    var result = '';

    if ( len( arguments.newExtension ) and ( left( arguments.newExtension, 1 ) neq "." ) ) {
      arguments.newExtension = ".#arguments.newExtension#";
    }
    result = reReplace( arguments.filename, "\.[^.]*$", arguments.newExtension );
    return result;

  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$clearLog
---------------------------------------------------------------------->
<cffunction name="$clearLog" access="private" output="false" >
  <cfscript>
    ArrayClear( $log );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$copyFile
---------------------------------------------------------------------->
<cffunction name="$copyFile" access="private" >
  <cfargument name="source" type="string" required="true" />
  <cfargument name="destination" type="string" required="true" />
  <cffile
    action      = "copy"
    source      = "#arguments.source#"
    destination = "#arguments.destination#" />
</cffunction>


<!---------------------------------------------------------------------
$directory
---------------------------------------------------------------------->
<cffunction name="$directory" access="private"  output="false">
  <cfset var returnValue = "">
  <cfset arguments.name = "returnValue">
  <cfdirectory attributeCollection="#arguments#">
  <cfreturn returnValue>
</cffunction>


<!---------------------------------------------------------------------
$installControllers
---------------------------------------------------------------------->
<cffunction name="$installControllers" output="false">
  <cfscript>
    $logMessage( "Installing Controllers" );
    
    $installDirectory(
      pluginDir    = "#application.dir.plugins#/insidehelp/controllers",
      targetDir    = application.dir.controllers,
      filter       = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"">#newLine#</cfcomponent>" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
installJavascripts
---------------------------------------------------------------------->
<cffunction name="installJavascripts" output="false">
  <cfscript>
    $addToLog( "Installing Javascript Files" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/javascripts",
      targetDir = application.dir.javascripts,
      filter    = "y_*.js",
      userTemplate = "// see ##pluginFile##" );
    $addToLog( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installModels
---------------------------------------------------------------------->
<cffunction name="$installModels" output="false">
  <cfscript>
    $logMessage( "Installing Models" );
    
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/models",
      targetDir = application.dir.models,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"" output=""false"">#newLine#</cfcomponent>" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installStylesheets
---------------------------------------------------------------------->
<cffunction name="$installStylesheets" access="private" output="false">
  <cfscript>
    $logMessage( "Installing Stylesheets" );
    
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/stylesheets",
      targetDir = application.dir.stylesheets,
      filter    = "y_*.css",
      userTemplate = "/* see ##pluginFile## */" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installViews
---------------------------------------------------------------------->
<cffunction name="$installViews" access="private" output="false">
  <cfscript>
    var controllerPath = "";

    var fileCount = 0;
    var fileIndex = 0;
    var fileName = "";
    var files = "";

    var folderCount = 0;
    var folderIndex = 0;
    var folderName = "";
    var folderPath = "";
    var folders = "";

    var newLine = chr(13) & chr(10);

    var pluginFile = "";
    var pluginPath = "";

    var userCode = "";
    var userFile = "";
    var viewPath = "";


    $clearLog();

    // Install Controllers
    $addToLog( "Installing Controllers" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/controllers",
      targetDir = application.dir.controllers,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Javascript Files
    $addToLog( "Installing Javascript Files" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/javascripts",
      targetDir = application.dir.javascripts,
      filter    = "y_*.js",
      userTemplate = "// see ##pluginFile##" );
    $addToLog( "" );


    // Install Models
    $addToLog( "Installing Models" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/models",
      targetDir = application.dir.models,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"" output=""false"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Stylesheets
    $addToLog( "Installing Stylesheets" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/stylesheets",
      targetDir = application.dir.stylesheets,
      filter    = "y_*.css",
      userTemplate = "/* see ##pluginFile## */" );
    $addToLog( '' );


    // Install Views
    $addToLog( "Installing Views" );
    folders = $directory(
      directory = "#application.dir.plugins#/insidehelp/views",
      type      = "dir" );

    folderCount = folders.recordCount;
    for ( folderIndex = 1; folderIndex lte folderCount; folderIndex = folderIndex + 1 ) {
      folder = folders[ 'name' ][ folderIndex ];
      // Ignore all folders that begin with a period (.) (for example, .svn )
      if ( ReFind( "^\.", folder ) ) {
        continue;
      }

      // Copy the Views for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );

      // Copy the Partials for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "_y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );
    }
    $addToLog( "" );
  </cfscript>
</cffunction>
<!---------------------------------------------------------------------
installEmbeddedFiles
---------------------------------------------------------------------->
<cffunction name="installEmbeddedFiles" output="false">
  <cfscript>
    var controllerPath = "";

    var fileCount = 0;
    var fileIndex = 0;
    var fileName = "";
    var files = "";

    var folderCount = 0;
    var folderIndex = 0;
    var folderName = "";
    var folderPath = "";
    var folders = "";

    var newLine = chr(13) & chr(10);

    var pluginFile = "";
    var pluginPath = "";

    var userCode = "";
    var userFile = "";
    var viewPath = "";


    $clearLog();

    // Install Controllers
    $addToLog( "Installing Controllers" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/controllers",
      targetDir = application.dir.controllers,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Javascript Files
    $addToLog( "Installing Javascript Files" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/javascripts",
      targetDir = application.dir.javascripts,
      filter    = "y_*.js",
      userTemplate = "// see ##pluginFile##" );
    $addToLog( "" );


    // Install Models
    $addToLog( "Installing Models" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/models",
      targetDir = application.dir.models,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"" output=""false"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Stylesheets
    $addToLog( "Installing Stylesheets" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/stylesheets",
      targetDir = application.dir.stylesheets,
      filter    = "y_*.css",
      userTemplate = "/* see ##pluginFile## */" );
    $addToLog( '' );


    // Install Views
    $addToLog( "Installing Views" );
    folders = $directory(
      directory = "#application.dir.plugins#/insidehelp/views",
      type      = "dir" );

    folderCount = folders.recordCount;
    for ( folderIndex = 1; folderIndex lte folderCount; folderIndex = folderIndex + 1 ) {
      folder = folders[ 'name' ][ folderIndex ];
      // Ignore all folders that begin with a period (.) (for example, .svn )
      if ( ReFind( "^\.", folder ) ) {
        continue;
      }

      // Copy the Views for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );

      // Copy the Partials for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "_y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );
    }
    $addToLog( "" );
  </cfscript>
</cffunction>
<!---------------------------------------------------------------------
installEmbeddedFiles
---------------------------------------------------------------------->
<cffunction name="installEmbeddedFiles" output="false">
  <cfscript>
    var controllerPath = "";

    var fileCount = 0;
    var fileIndex = 0;
    var fileName = "";
    var files = "";

    var folderCount = 0;
    var folderIndex = 0;
    var folderName = "";
    var folderPath = "";
    var folders = "";

    var newLine = chr(13) & chr(10);

    var pluginFile = "";
    var pluginPath = "";

    var userCode = "";
    var userFile = "";
    var viewPath = "";


    $clearLog();

    // Install Controllers
    $addToLog( "Installing Controllers" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/controllers",
      targetDir = application.dir.controllers,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Javascript Files
    $addToLog( "Installing Javascript Files" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/javascripts",
      targetDir = application.dir.javascripts,
      filter    = "y_*.js",
      userTemplate = "// see ##pluginFile##" );
    $addToLog( "" );


    // Install Models
    $addToLog( "Installing Models" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/models",
      targetDir = application.dir.models,
      filter    = "y_*.cfc",
      userTemplate = "<cfcomponent extends=""##pluginName##"" output=""false"">#newLine#</cfcomponent>" );
    $addToLog( "" );


    // Install Stylesheets
    $addToLog( "Installing Stylesheets" );
    $installDirectory(
      pluginDir = "#application.dir.plugins#/insidehelp/stylesheets",
      targetDir = application.dir.stylesheets,
      filter    = "y_*.css",
      userTemplate = "/* see ##pluginFile## */" );
    $addToLog( '' );


    // Install Views
    $addToLog( "Installing Views" );
    folders = $directory(
      directory = "#application.dir.plugins#/insidehelp/views",
      type      = "dir" );

    folderCount = folders.recordCount;
    for ( folderIndex = 1; folderIndex lte folderCount; folderIndex = folderIndex + 1 ) {
      folder = folders[ 'name' ][ folderIndex ];
      // Ignore all folders that begin with a period (.) (for example, .svn )
      if ( ReFind( "^\.", folder ) ) {
        continue;
      }

      // Copy the Views for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );

      // Copy the Partials for this folder
      $installDirectory(
        pluginDir = "#application.dir.plugins#/insidehelp/views/#folder#",
        targetDir = "#application.dir.views#/#folder#",
        filter    = "_y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );
    }
    $addToLog( "" );
  </cfscript>
</cffunction>




<!---------------------------------------------------------------------
$loadFromTextFile
---------------------------------------------------------------------->
<cffunction name="$loadFromTextFile" access="private" output="false" returnType="string">
  <cfargument name="file" type="string" required="true" />

  <cfset result = "">
  <cffile action="read" file="#arguments.file#" variable="result" />
  <cfreturn result />
</cffunction>


<!---------------------------------------------------------------------
$logMessage
---------------------------------------------------------------------->
<cffunction name="$logMessage" access="private" output="false">
  <cfargument name="message" type="string" required="true" >
  <cfscript>
    ArrayAppend( log, arguments.message );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installFiles
---------------------------------------------------------------------->
<cffunction name="$installFiles" access="private" output="false">
  <cfargument name="pluginDir" type="string" required="true">
  <cfargument name="targetDir" type="string" required="true">
  <cfargument name="filter" type="string" required="true">
  <cfargument name="userTemplate" type="string" required="true">
  <cfscript>
    var files = "";
    var fileCount = 0;
    var fileIndex = 0;

    var pluginFile = "";
    var pluginName = "";
    var pluginPath = "";

    var targetPath = "";

    var userCode = "";
    var userFile = "";
    var userPath = "";
  </cfscript>


  <!--- check arguments.filter begins with 'y_' or '_y_' --->
  <cfif not ReFindNoCase( "^(y_|_y_)", arguments.filter ) >
    <cfthrow message="argument filter (#arguments.filter#) must begin with 'y_' or '_y_' " >
  </cfif>

  <cfscript>
    // Make sure that the target directory exists
    $makeDirectories( arguments.targetDir );

    files = $directory(
      directory = arguments.pluginDir,
      filter    = arguments.filter,
      type      = "file" );

    fileCount = files.recordCount;
    for ( fileIndex = 1; fileIndex lte fileCount; fileIndex = fileIndex + 1 ) {
      pluginFile = files[ 'name' ][ fileIndex ];

      // Copy plugin file to controllers folder
      pluginPath = "#arguments.pluginDir#/#pluginFile#";
      targetPath = "#arguments.targetDir#/#pluginFile#";
      $copyFile( pluginPath, targetPath );
      $addToLog( "  " & targetPath );

      // Create user file if user file does not exist
      // or if file exists and has less than 11 lines.
      userFile = ReReplaceNoCase( pluginFile, "^(y_|_y)", "" );
      userPath = "#arguments.targetDir#/#userFile#";

      if ( not FileExists( userPath ) ) {
        lineCount = 0;
      }
      else {
        lineCount = listLen( $loadFromTextFile( userPath ), chr( 10 ) ) + 1;
      }

      if ( lineCount lte 11 ) {
      	pluginName = $changeFileExtension( pluginFile, '' );

      	userCode = arguments.userTemplate;
        userCode = ReReplaceNoCase( userCode, "##pluginFile##", pluginFile );
        userCode = ReReplaceNoCase( userCode, "##pluginName##", pluginName );
        $saveToTextFile( userPath, userCode );
        $addToLog( "  " & userPath );
      }
    }
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$makeDirectories
see http://java.sun.com/j2se/1.4.2/docs/api/java/io/File.html
---------------------------------------------------------------------->
<cffunction name="$makeDirectories" access="private" output="false">

  <cfargument name="directory" type="string" required="true" />
  <cfscript>
    var systemDirectory = createObject("java", "java.io.File").init( arguments.directory );
    systemDirectory.mkdirs();
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$queryOfQuery
---------------------------------------------------------------------->
<cffunction name="$queryOfQuery" access="private" output="false" returnType="query">
  <cfargument name="sql" type="query" required="true" >

  <cfscript>
    var result = "";
  </cfscript>

  <cfquery dbtype="query" name="result" >
    #arguments.sql#
  </cfquery>

  <cfscript>
    return result;
  </cfscript>

</cffunction>


<!---------------------------------------------------------------------
$saveToTextFile
---------------------------------------------------------------------->
<cffunction name="$saveToTextFile" access="private" output="false" >

  <cfargument name="file" type="string" required="true" />
  <cfargument name="output" type="string" required="true" />

  <cffile action="write" file="#arguments.file#" output="#arguments.output#" />
</cffunction>



</cfcomponent>