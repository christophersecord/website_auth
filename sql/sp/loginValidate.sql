/**
 * @author christophersecord
 * @date 20231001
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists wa_loginValidate;

DELIMITER //

/** loginValidate
 * when a user returns after an initial login, this procedure looks up their userID and loginTime
 * given their login token cookie, which is in the format, <loginID>-<loginToken>
 */
create procedure wa_loginValidate (
	in pLoginTokenCookie varchar(41),

	out pUserID int,
	out pLoginTime int, -- seconds since the client logged in
	out pLogoutTime int -- seconds until the client will be logged out
)
begin

	declare vLoginDateTime datetime;
	declare vLogoutDateTime datetime;

	-- a loginTokenString is a cookie in the format <userID>-<loginToken>
	-- extract the userID and the token
	declare vLoginID varchar(10);
	declare vLoginToken varchar(50);

	-- get the log-out delta, or use a default
	declare vTimeToStayLoggedIn int default 10;

	-- if theres a "-" in the cookie, then its probably in the right format
	if (locate('-',pLoginTokenCookie)) then
    
		set vLoginID = substring(pLoginTokenCookie,1,locate('-',pLoginTokenCookie)-1);
		set vLoginToken = substring(pLoginTokenCookie,locate('-',pLoginTokenCookie)+1);

		-- lookup the login record given the id and token
		select userID, loginTime
		into pUserID, vLoginDateTime
		from wa_login
		where
			loginID = vLoginID
			and loginToken = vLoginToken
			and logoutTime > now()
		;

		-- if the login was found
		if (pUserID is not null) then
        
        
			set vLogoutDateTime = now() + interval vTimeToStayLoggedIn minute;

			-- update the log out time
			update wa_login
			set
				logoutTime = vLogoutDateTime,
                hitCount = hitCount+1
			where loginID = vLoginID
			;

			-- set the loginTime and logoutTime in seconds (for the web UI)
            set pLoginTime = timeStampDiff(second, vLoginDateTime, now());
			set pLogoutTime = timeStampDiff(second, now(), vLogoutDateTime);
		end if;

	end if;

end //

