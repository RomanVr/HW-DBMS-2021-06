select firstName, patronymic, lastName, attributes->>'$.tel_mobile' as 'tel', attributes->>'$.tel_work'  as 'tel_work'
	from People 
		where JSON_SEARCH(attributes, 'one',  '+7%') is not null;
