VirtualExhibition.Role = DS.Model.extend
    name: DS.attr 'string'
    users: DS.hasMany 'user', async: true