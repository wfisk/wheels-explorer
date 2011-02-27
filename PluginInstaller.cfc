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
    
    // removing trailing slash
    if ( Right( $dir.root, 1 ) is "/" ) {
      $dir.root = Left( $dir.root, Len( $dir.root ) - 1 );  
    } 
    
    
    $dir.controllers = $dir.root & "/controllers";
    $dir.javascripts = $dir.root & "/javascripts";
    $dir.models      = $dir.root & "/models";
    $dir.plugin      = $dir.root & "/plugins/#$pluginName#";
    $dir.stylesheets = $dir.root & "/stylesheets";
    $dir.views       = $dir.root & "/views";
    
    $log = ArrayNew(1);
    $newLine = CreateObject("java", "java.lang.System").getProperty("line.separator");
    
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
    $installJavascriptFiles();
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
    $removeJavascriptFiles();
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

    if ( Len( arguments.newExtension ) and ( Left( arguments.newExtension, 1 ) neq "." ) ) {
      arguments.newExtension = ".#arguments.newExtension#";
    }
    result = REReplace( arguments.filename, "\.[^.]*$", arguments.newExtension );
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
$deleteFile
---------------------------------------------------------------------->
<cffunction name="$deleteFile" output="false">
  <cfargument name="filename" type="string" required="true" />
  <cffile action="delete" file="#arguments.filename#" >
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
<cffunction name="$installControllers" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Installing Controllers</b>" );
    
    $installFiles(
      pluginDir    = "#$dir.plugin#/controllers",
      targetDir    = $dir.controllers,
      filter       = "y_*.cfc",
      userTemplate = 
        "<cfcomponent extends=""##pluginName##"">" & $newLine &
        "</cfcomponent>" );
        
    $logMessage( "" );
      
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

      // Copy plugin file to target folder
      pluginPath = "#arguments.pluginDir#/#pluginFile#";
      targetPath = "#arguments.targetDir#/#pluginFile#";
      $copyFile( pluginPath, targetPath );
      $logMessage( "  " & targetPath & " installed" );

      // Create user file if user file does not exist
      userFile = REReplaceNoCase( pluginFile, "^(y_|_y)", "" );
      userPath = "#arguments.targetDir#/#userFile#";

      if ( not FileExists( userPath ) ) {
      	pluginName = $changeFileExtension( pluginFile, '' );

      	userCode = arguments.userTemplate;
        userCode = REReplaceNoCase( userCode, "##pluginFile##", pluginFile );
        userCode = REReplaceNoCase( userCode, "##pluginName##", pluginName );
        $saveToTextFile( userPath, userCode );
        $logMessage( "  " & userPath & " installed" );
      }
    }
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installJavascriptFiles
---------------------------------------------------------------------->
<cffunction name="$installJavascriptFiles" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Installing Javascript Files</b>" );
    
    $installFiles(
      pluginDir    = "#$dir.plugin#/javascripts",
      targetDir    = $dir.javascripts,
      filter       = "y_*.js",
      userTemplate = "// see ##pluginFile##" );

    $logMessage( "" );
      
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installModels
---------------------------------------------------------------------->
<cffunction name="$installModels" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Installing Models</b>" );
    
    $installFiles(
      pluginDir    = "#$dir.plugin#/models",
      targetDir    = $dir.models,
      filter       = "y_*.cfc",
      userTemplate = 
        "<cfcomponent extends=""##pluginName##"" output=""false"">" & $newLine &
        "</cfcomponent>" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installStylesheets
---------------------------------------------------------------------->
<cffunction name="$installStylesheets" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Installing Stylesheets</b>" );
    
    $installFiles(
      pluginDir    = "#$dir.plugin#/stylesheets",
      targetDir    = $dir.stylesheets,
      filter       = "y_*.css",
      userTemplate = "/* see ##pluginFile## */" );
      
    $logMessage( "" );
    
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$installViews
will install both views and partials
---------------------------------------------------------------------->
<cffunction name="$installViews" access="private" output="false">
  <cfscript>
    var folder = "";
    var folderCount = 0;
    var folderIndex = 0;
    var folders = "";

    $logMessage( "<b>Installing Views</b>" );
    
    folders = $directory(
      directory = "#$dir.plugin#/views",
      type      = "dir" );

    folderCount = folders.recordCount;
    for ( folderIndex = 1; folderIndex lte folderCount; folderIndex = folderIndex + 1 ) {
      folder = folders[ 'name' ][ folderIndex ];
      // Ignore all folders that begin with a period (.) (for example, .svn )
      if ( REFind( "^\.", folder ) ) {
        continue;
      }

      // Install Views
      $installFiles(
        pluginDir    = "#$dir.plugin#/views/#folder#",
        targetDir    = "#$dir.views#/#folder#",
        filter       = "y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );

      // Install Partials
      $installFiles(
        pluginDir    = "#$dir.plugin#/views/#folder#",
        targetDir    = "#$dir.views#/#folder#",
        filter       = "_y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );
    }
    
    $logMessage( "" );
    
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$logMessage
---------------------------------------------------------------------->
<cffunction name="$logMessage" access="private" output="false">
  <cfargument name="message" type="string" required="true" >
  <cfscript>
    ArrayAppend( $log, arguments.message );
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
$removeControllers
---------------------------------------------------------------------->
<cffunction name="$removeControllers" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Removing Controllers</b>" );
    
    $removeFiles(
      pluginDir    = "#$dir.plugin#/controllers",
      targetDir    = $dir.controllers,
      filter       = "y_*.cfc" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$removeFiles
---------------------------------------------------------------------->
<cffunction name="$removeFiles" access="private" output="false">
  <cfargument name="pluginDir" type="string" required="true">
  <cfargument name="targetDir" type="string" required="true">
  <cfargument name="filter" type="string" required="true">
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

      // Remove target file
      targetPath = "#arguments.targetDir#/#pluginFile#";
      if ( FileExists( targetPath ) ) {
        $deleteFile( targetPath );
        $logMessage( "  " & targetPath & " deleted." );
      }

      // We cannot remove the user file so just write a message
      userFile = REReplaceNoCase( pluginFile, "^(y_|_y)", "" );
      userPath = "#arguments.targetDir#/#userFile#";
      
      if ( FileExists( userPath ) ) {
        $logMessage( "  Please manually delete " & userPath & "." );
      }
    }
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$removeJavascriptFiles
---------------------------------------------------------------------->
<cffunction name="$removeJavascriptFiles" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Removing Javascript Files</b>" );
    
    $removeFiles(
      pluginDir    = "#$dir.plugin#/javascripts",
      targetDir    = $dir.javascripts,
      filter       = "y_*.js" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$removeModels
---------------------------------------------------------------------->
<cffunction name="$removeModels" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Removing Models</b>" );
    
    $removeFiles(
      pluginDir    = "#$dir.plugin#/models",
      targetDir    = $dir.models,
      filter       = "y_*.cfc" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$removeStylesheets
---------------------------------------------------------------------->
<cffunction name="$removeStylesheets" access="private" output="false">
  <cfscript>
    $logMessage( "<b>Removing Stylesheets</b>" );
    
    $removeFiles(
      pluginDir    = "#$dir.plugin#/stylesheets",
      targetDir    = $dir.stylesheets,
      filter       = "y_*.css" );
      
    $logMessage( "" );
  </cfscript>
</cffunction>


<!---------------------------------------------------------------------
$removeViews
---------------------------------------------------------------------->
<cffunction name="$removeViews" access="private" output="false">
  <cfscript>
    var folder = "";
    var folderCount = 0;
    var folderIndex = 0;
    var folders = "";

    $logMessage( "<b>Removing Views</b>" );
    
    folders = $directory(
      directory = "#$dir.plugin#/views",
      type      = "dir" );

    folderCount = folders.recordCount;
    for ( folderIndex = 1; folderIndex lte folderCount; folderIndex = folderIndex + 1 ) {
      folder = folders[ 'name' ][ folderIndex ];
      // Ignore all folders that begin with a period (.) (for example, .svn )
      if ( REFind( "^\.", folder ) ) {
        continue;
      }

      // Install Views
      $installFiles(
        pluginDir    = "#$dir.plugin#/views/#folder#",
        targetDir    = "#$dir.views#/#folder#",
        filter       = "y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );

      // Install Partials
      $installFiles(
        pluginDir    = "#$dir.plugin#/views/#folder#",
        targetDir    = "#$dir.views#/#folder#",
        filter       = "_y_*.cfm",
        userTemplate = "<cfinclude template=""##pluginFile##"" />" );
    }
    
    $logMessage( "" );
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