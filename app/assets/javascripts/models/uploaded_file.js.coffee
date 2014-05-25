# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.UploadedFile = DS.Model.extend
  fileId: DS.attr 'number'
  name: DS.attr 'string'
  fileGroup: DS.attr 'string'
  savedFileName: DS.attr 'string'
  mimeType: DS.attr 'string'
