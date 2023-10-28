

<cfoutput>

<form action="#request.script_name#" method="post">

	<label for="username">Username:</label>
	<input type="text" id="username" name="username" required><br>

	<label for="password">Password:</label>
	<input type="password" id="password" name="passwd" required><br>

	<input type="submit" value="Login">

</form>

</cfoutput>