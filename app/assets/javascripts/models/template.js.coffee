# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Template = DS.Model.extend
  name: DS.attr 'string'
  jumbotronAvailable: DS.attr 'boolean'
