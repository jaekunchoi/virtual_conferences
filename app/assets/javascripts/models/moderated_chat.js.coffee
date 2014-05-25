# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.ModeratedChat = DS.Model.extend
  message: DS.attr 'string'
  webcast: DS.belongsTo 'VirtualExhibition.Webcast'
  fromUserId: DS.attr 'number'
  toUserId: DS.attr 'number'
  approved: DS.attr 'boolean'
