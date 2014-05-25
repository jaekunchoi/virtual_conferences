# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Webcast = DS.Model.extend
  name: DS.attr 'string'
  hall: DS.belongsTo 'VirtualExhibition.Hall'
  webcastType: DS.attr 'string'
  mediaType: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
  details: DS.attr 'string'
  template: DS.belongsTo 'VirtualExhibition.Template'
  backgroundColour: DS.attr 'string'
