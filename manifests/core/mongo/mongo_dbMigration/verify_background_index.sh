#!/usr/bin/env sh

if [ -f "indexes.js" ]; then
    indexes="./indexes.js"
else
    indexes="scripts/mongo_dbMigration/indexes.js"
fi

missing_background=$(grep -n "\.createIndex" ${indexes} | grep -v "background: true")
if [ -n "$missing_background" ]; then
    echo "There are indexes without 'background: true' set:"
    echo "$missing_background"
    exit 1
fi

exit 0