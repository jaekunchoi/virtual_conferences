VirtualExhibition.Router.map ()->
	@resource 'users', ->
		@route 'new'
		@resource 'user', path: ':user_id'
	@resource 'venues'