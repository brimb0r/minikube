db.getCollectionNames().forEach(function(c) {
    if(!c.match("^migration")) {
        print("Removing: " + c);
        print(db.getCollection(c).remove({}));
    }
});
load("card.js");
