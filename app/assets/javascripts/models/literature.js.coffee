# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Literature = DS.Model.extend
  name: DS.attr 'string'
  fileCategory: DS.attr 'string'
  assetType: DS.belongsTo 'VirtualExhibition.AssetType'
  expirationDate: DS.attr 'date'
  share: DS.attr 'boolean'
  description: DS.attr 'string'
  fileUrl: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'
