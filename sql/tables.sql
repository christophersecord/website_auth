

create table wa_user (
	userID int not null auto_increment primary key,
	emailAddress varchar(250) not null,

	-- passwd is a SHA-2 hash
	passwd char(56) not null,

	dateCreated timestamp not null default now(),

	unique(emailAddress)
);
