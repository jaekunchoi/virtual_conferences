VirtualExhibition.UsersNewController = Ember.ObjectController.extend
  title: ["Mr", "Mrs", "Dr", "Miss", "Ms"]

  startEditing: ->
    @transaction = @get('store').transaction()
    @set 'model', @transaction.createRecord(VirtualExhibition.User, {})

  stopEditing: ->
    if(@transaction)
      @transaction.rollback()
      @transaction = null

  actions:
    save: ->
      @transaction.commit()
      @transaction = null

    cancel: ->
      @stopEditing()
      @transitionToRoute 'users'

  onDidCreate: (user)->
    @store.push 'user', user.get('data')
    @transitionToRoute 'user', user
