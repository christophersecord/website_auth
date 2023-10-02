
-- OMFG please read this file and tell if its okay to go.  
/** stored procedure for wevbsite auth project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists wa_userCreate;

DELIMITER //

/** clientCreate
 * creates a client
 */
create procedure wa_userCreate (
	in pUserName varchar(250),
	in pPasswd varchar(250),

	out userID int = 0
)
begin

	if not exists (
		select * from wa_user where userName = pUserName
	) then

		-- the passwd column is the SHA265 of username+password
		-- never store plaintext passwords
		-- never store raw hashes (because those are vulnerable to dictionary attacks)
		insert wa_user (
			username,
			passwd
		) values (
			pEmailAddres,
			sha2(pUserName+pPasswd,224)
		)
		;

		set userID = last_insert_id();
	end if;
end //

