# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Product = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'
  productUrl: DS.attr 'string'
  imageId: DS.attr 'number'
  requestInfo: DS.attr 'boolean'
  emailNotification: DS.attr 'boolean'
  emails: DS.attr 'string'
  user: DS.belongsTo 'VirtualExhibition.User'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'
