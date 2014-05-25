VirtualExhibition.User = DS.Model.extend
	email: DS.attr 'string'
	password: DS.attr 'string'
	title: DS.attr 'string'
	first_name: DS.attr 'string'
	last_name: DS.attr 'string'
	position: DS.attr 'string'
	work_phone: DS.attr 'string'
	company: DS.attr 'string'
	sign_in_count: DS.attr 'number'
	last_sign_in_ip: DS.attr 'string'
	confirmed_at: DS.attr 'date'
	created_at: DS.attr 'date'
	venues: DS.hasMany 'venue', async: true
	roles: DS.hasMany 'role', async: true