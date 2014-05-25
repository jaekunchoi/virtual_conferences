VirtualExhibition.UserRoute = Ember.Route.extend
	setupController: (controller, model) ->
		@_super.apply @, arguments
		controller.stopEditing() if controller.get('isEditing')
		@controllerFor('users').set 'activeUserId', model.get 'id'

	deactivate: ->
		controller = @controllerFor 'user'
		controller.stopEditing() if controller.get('isEditing')
		@controllerFor('users').set 'activeUserId', null
