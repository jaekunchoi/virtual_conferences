# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Hall = DS.Model.extend
  name: DS.attr 'string'
  templateId: DS.attr 'number'
  backgroundId: DS.attr 'number'
  colour: DS.attr 'string'
  greeting: DS.attr 'string'
  greetingType: DS.attr 'string'
  greetingEnable: DS.attr 'boolean'
  jumbotron: DS.attr 'string'
  jumbotronEnable: DS.attr 'boolean'
