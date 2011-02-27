<cfsetting enablecfoutputonly="true">
<cfscript>
  //----------------------------------------------------------------
  // Parameters
  //----------------------------------------------------------------
  if ( not StructKeyExists( url, "command") ) {
    url.command = "";
  }
  if ( not StructKeyExists( form, "command") ) {
    form.command = url.command;
  }
  
  pluginName = "wheelsexplorer";


  //----------------------------------------------------------------
  // Variables
  //----------------------------------------------------------------
  command = LCase( ListFirst( form.command, ' ' ) );
  message = '';
  newLine = Chr(13) & Chr(10);
  pluginInstaller = CreateObject( 'component', 'PluginInstaller' ).init("whe");

   
  //----------------------------------------------------------------
  // Deal with actions
  //----------------------------------------------------------------
  switch ( command ) {
    case 'install':
      pluginInstaller.installEmbeddedFiles();
      message = ArrayToList( pluginInstaller.getLog(), "<br/>" );
      break;

    case 'remove':
      pluginInstaller.removeEmbeddedFiles();
      message = ArrayToList( pluginInstaller.getLog(), "<br />" );
      break;
  }
</cfscript>
<cfoutput>
  <cfinclude template="css.cfm">
  <h1>Wheels Explorer</h1>
  <p>
    Wheels Explorer provides a way to easily explore your Wheels application.
    In order for Wheels Explorer to work, a small number of files will require
    to be copied from the plugins folder into your application folders.
    Click on <i>Install Embedded Files</i> to complete the installation.
  </p>

  <form action="#CGI.script_name & '?' & CGI.query_string#" method="post">
    <p><input type="submit" name="command" value="Install Embedded Files"></p>
    <p><input type="submit" name="command" value="Remove Embedded Files"></p>
  </form>

  <cfif message neq "" >
    <div style="border:1px ##ff5522 solid;">
      #message#
    </div>
  </cfif>  

</cfoutput>
<cfsetting enablecfoutputonly="false">