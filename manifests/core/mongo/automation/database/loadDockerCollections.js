db.getCollectionNames().forEach(function(c) {
    if(!c.match("^migration")) {
        db.getCollection(c).remove({});
    }
});

load("card.js");