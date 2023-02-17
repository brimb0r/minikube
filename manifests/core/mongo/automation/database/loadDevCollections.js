db.getCollectionNames().forEach(function(c) {
    if(!c.match("^migration")) {
        print("Removing: " + c);
        db.getCollection(c).remove({});
    }
});


load("card.js");

