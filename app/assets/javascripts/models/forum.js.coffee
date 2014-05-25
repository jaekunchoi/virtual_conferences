# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Forum = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
