/**
 * @author christophersecord
 * @date 20231015
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists wa_userAuthenticate;

DELIMITER //

/** userAuthenticate
 * authenticates a user given their username and password
 */
create procedure wa_userAuthenticate (
	in pUserName varchar(250),
	in pPasswd varchar(250),

	out pUserID int
)
begin

	select userID into pUserID
	from wa_user
	where
		userName = pUserName
		and passwd = sha2(concat(pUserName,pPasswd),224)
	;

	-- if no rows were found, return 0
	if (pUserID is null) then set pUserID = 0; end if;

end //