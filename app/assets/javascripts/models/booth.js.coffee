# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Booth = DS.Model.extend
  name: DS.attr 'string'
  companyWebsite: DS.attr 'string'
  socialMedia: DS.attr 'string'
  contactInfo: DS.attr 'string'
  email: DS.attr 'string'
  aboutUs: DS.attr 'string'
  greetingType: DS.belongsTo 'VirtualExhibition.GreetingType'
  createdAt: DS.attr 'date'
  updatedAt: DS.attr 'date'
