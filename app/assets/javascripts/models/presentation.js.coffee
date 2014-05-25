# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Presentation = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'
  presentationUrl: DS.attr 'string'
  relevantLogoId: DS.attr 'number'
  user: DS.belongsTo 'VirtualExhibition.User'
