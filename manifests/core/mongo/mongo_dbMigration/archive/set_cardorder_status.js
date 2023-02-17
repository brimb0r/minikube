var name = 'set_cardorder_status';
var m = db.migration.findOne({'name': name});

var user =  '';
var a = db.runCommand({connectionStatus : 1}).authInfo.authenticatedUsers[0];
if (a) {
    user = a.user;
}

if (m === null) {

    db.cardorder.find({}).forEach(function(c){
        if (!c.events || c.events.length == 0) {
            return;
        }

        var latestEvent = c.events[c.events.length -1];
        c.status = latestEvent.status;
        c.statusmessage = latestEvent.statusmessage;
        db.cardorder.update({_id: c._id}, c);
    });

    m = {};
    m.name = name;
    m.success = 'true';
    m.created = new Date();
    if (user) {
        m.user = user;
    }

    db.migration.insert(m);
    printjson(m);
} else {
    print('Migration ' + name + ' already executed');
}
