VirtualExhibition.UsersNewRoute = Ember.Route.extend
	model: ->
		null

	setupController: (controller) ->
		@_super.apply @, arguments
		controller.startEditing()

