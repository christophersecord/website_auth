/**
 * @author christophersecord
 * @date 20231002
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists wa_userLogin;

DELIMITER //

/** clientLogin
 * logs a user in by creating a login record
 */
create procedure wa_userLogin (
	in pUserID int,

	out pLoginTokenCookie varchar(41)
)
begin

	declare vLoginID int;
	declare vLoginToken char(36);
	declare vLogoutDateTime datetime;

	-- get the log-out delta, or use a default
	declare vTimeToStayLoggedIn int default 10;
	set vLogoutDateTime = now() + interval vTimeToStayLoggedIn minute;

	set vLoginToken = uuid();

	-- TODO: lookup client preferences for when logout will occur
	insert wa_login (loginToken,userID,loginTime,logOutTime)
	values (vLoginToken,pUserID,now(),vLogoutDateTime);

	set vLoginID = last_insert_id();
	set pLoginTokenCookie = concat(vLoginID,'-',vLoginToken);

end //

