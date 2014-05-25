# for more details see: http://emberjs.com/guides/models/defining-models/

VirtualExhibition.Sponsor = DS.Model.extend
  name: DS.attr 'string'
  sponsorshipLevel: DS.attr 'string'
  link: DS.attr 'string'
