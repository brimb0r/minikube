print('Creating Indexes...');

var a = db.runCommand({connectionStatus: 1}).authInfo.authenticatedUsers[0];
if (!a) {
    print('Setting feature compatibility to 4.2');
    db.getMongo().getDB("admin");
    var result = db.adminCommand({setFeatureCompatibilityVersion: "4.2"});
    print(result);
}

//NOTE: make sure every index is specified as background.  This grep will show any indexes without "background: true":
//grep "\.createIndex" indexes.js | grep -v "background: true"

print('...done creating indexes');
