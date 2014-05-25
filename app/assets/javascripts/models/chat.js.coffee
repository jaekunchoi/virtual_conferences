# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Chat = DS.Model.extend
  fromUser: DS.attr 'number'
  toUser: DS.attr 'number'
  message: DS.attr 'string'
