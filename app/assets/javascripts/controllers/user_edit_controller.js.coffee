VirtualExhibition.UserEditController = Ember.ObjectController.extend
  needs: ['user']
  title: ["Mr", "Mrs", "Dr", "Miss", "Ms"]

  startEditing: ->
    user = @get 'model'
    store = @get('store')
    @store = store

  stopEditing: ->
    store = @store
    if(@store)
      @store.rollback()
      @store = undefined

  actions:
    save: ->
      @modelFor('user').save()
      @get('controllers.user').send('stopEditing')

    cancel: ->
      @get('controllers.user').send('stopEditing')

