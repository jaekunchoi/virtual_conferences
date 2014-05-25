VirtualExhibition.Venue = DS.Model.extend
  name: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
  colour: DS.attr 'string'
  logo: DS.attr 'string'
  backgroundImage: DS.attr 'string'
