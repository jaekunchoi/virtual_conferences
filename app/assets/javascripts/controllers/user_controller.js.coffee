VirtualExhibition.UserController = Ember.ObjectController.extend
  isEditing: false
  needs: ['userEdit']

  actions:
    startEditing: ->
      userEditController = @get 'controllers.userEdit'
      userEditController.set 'model', @get 'model'
      userEditController.startEditing()
      @set 'isEditing', true

    stopEditing: ->
      userEditController = @get 'controllers.userEdit'
      userEditController.stopEditing()
      @set 'isEditing', false

    destroyRecord: ->
      if window.confirm "Are you sure you want to delete this contact?"
        @get('model').deleteRecord()
        @get('store').commit()

        # return to the main contacts listing page
        @get('target.router').transitionTo 'users.index'
