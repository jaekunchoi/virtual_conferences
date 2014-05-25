VirtualExhibition.IndexRoute = Ember.Route.extend
	model: ->
		@store.find 'user'