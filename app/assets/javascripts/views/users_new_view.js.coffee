VirtualExhibition.UsersNewView = Ember.View.extend
  didInsertElement: ->
    @$('input:first').focus()