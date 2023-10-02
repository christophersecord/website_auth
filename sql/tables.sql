
/**
 * one row per user that is known by the system
 */
create table wa_user (
	userID int not null auto_increment primary key,
	userName varchar(250) not null,

	-- passwd is a SHA-2 hash
	passwd char(56) not null,

	dateCreated timestamp not null default now(),

	unique(userName)
);

/**
 * one row per unique login by a user
 * unique logins are defined by presenting the login token
 */
create table wa_login (
	loginID int not null auto_increment primary key,
	loginToken char(36) not null,

	userID int not null,

	loginTime datetime not null,
	logoutTime datetime not null,
	hitCount int not null default 1,

	foreign key(userID) references wa_user(userID)
);