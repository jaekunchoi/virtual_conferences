# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Partner = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'
  partnerUrl: DS.attr 'string'
  logoId: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'
