# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Video = DS.Model.extend
  name: DS.attr 'string'
  fileCategory: DS.attr 'string'
  assetType: DS.belongsTo 'VirtualExhibition.AssetType'
  expirationDate: DS.attr 'string'
  share: DS.attr 'boolean'
  description: DS.attr 'string'
  videoSource: DS.attr 'string'
  videoDuration: DS.attr 'number'
  thumbnail: DS.attr 'string'
