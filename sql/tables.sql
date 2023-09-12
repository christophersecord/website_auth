

create table wa_user (
	userID int not null auto_increment primary key,
	emailAddress varchar(250) not null,

	-- passwd is a SHA-2 hash
	passwd char(56) not null,

	dateCreated timestamp not null default now(),

	unique(emailAddress)
);


create table wa_login (
	loginID int not null auto_increment primary key,
	loginToken char(36) not null,

	userID int not null,

	loginTime datetime not null,
	logoutTime datetime not null,

	foreign key(userID) references wa_user(userID)
);