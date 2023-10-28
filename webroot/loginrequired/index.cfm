<!--- the name of the login cookie - has to be unique to your domain --->
<cfset LOGINCOOKIE = "wa_logintoken"/>

<!--- the script name minus "index.cfm" - used for form actions --->
<cfset request.script_name = replace(cgi.script_name,"/index.cfm","/")/>

<!--- assume the user isnt logged in --->
<cfset userID = 0/>

<!--- check for a request to log in (which would override a token) --->
<cfif structKeyExists(form,"username") and structKeyExists(form,"passwd")>

	<!--- attempt to log the user in --->
	<cfstoredproc procedure="wa_userAuthenticate" datasource="wa">
		<cfprocparam dbvarname="pUserName" value="#form.username#"/>
		<cfprocparam dbvarname="pPasswd" value="#form.passwd#"/>
		<cfprocparam dbvarname="pUserID" type="out" variable="userID"/>
	</cfstoredproc> 

	<!--- if the username/passwd was valid, then the variable userID is non-zero --->
	<cfif userID>

		<!--- set the login cookie --->
		<cfstoredproc procedure="wa_userLogin" datasource="wa">
			<cfprocparam dbvarname="pUserID" value="#userID#"/>
			<cfprocparam dbvarname="pLoginTokenCookie" type="out" variable="loginToken"/>
		</cfstoredproc>

		<cfset cookie[LOGINCOOKIE] = loginToken/>

	<!--- else redirect to the failed login template --->
	<cfelse>
		<cfinclude template="loginfailed.cfm"/>
		<cfabort/>
	</cfif>
</cfif>


<!--- if not logged in by the above code, but the login cookie exists --->
<cfif (userID eq 0) and structKeyExists(cookie,LOGINCOOKIE)>

	<!--- validate it --->
	<cfstoredproc procedure="wa_loginValidate" datasource="wa">
		<cfprocparam dbvarname="pLoginTokenCookie" value="#cookie[LOGINCOOKIE]#"/>

		<cfprocparam dbvarname="pUserID" type="out" variable="userID"/>
		<cfprocparam dbvarname="pLoginTime" type="out" variable="loginTime"/>
		<cfprocparam dbvarname="pLogoutTime" type="out" variable="logoutTime"/>		
	</cfstoredproc>

	<!--- if the user is now logged in, the local variable "userID" is non-zero --->
</cfif>

<!--- if the user isnt logged in, force a login --->
<cfif userID eq 0>

	<cfinclude template="loginform.cfm"/>
	<cfabort/>

</cfif>

<!--- the user is logged in!! --->
<cfoutput><h1>logged in as #userID#</h1></cfoutput>