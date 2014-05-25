# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.BoothsTag = DS.Model.extend
  boothId: DS.attr 'number'
  tagId: DS.attr 'number'
