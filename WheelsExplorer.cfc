<cfcomponent output="false">

<cfinclude template="initPluginRootDir.cfm">	
	
<cffunction name="init">
  <cfscript>	  
	  this.version = "1.2";
	  
	  application.plugins.wheelsExplorer.dir.root = this.pluginRootDir;	  
	  
	  return this;
  </cfscript>		
</cffunction>	
		

		
</cfcomponent>