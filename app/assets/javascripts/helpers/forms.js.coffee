Ember.Handlebars.helper 'submitButton', (text) ->
  new Handlebars.SafeString '<button type="submit" class="btn btn-primary">' + text + '</button>'

Ember.Handlebars.helper 'mailto', (address) ->
  if address
  	new Handlebars.SafeString '<a href="mailto:' + address + '" />' + address + '</a>'