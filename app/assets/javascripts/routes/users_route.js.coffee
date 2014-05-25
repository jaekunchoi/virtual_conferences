VirtualExhibition.UsersIndexRoute = Ember.Route.extend
	actions:
		delete: (user) ->
			user.deleteRecord()
			user.save()
	model: ->
		@store.find 'user'