import QtQuick 2.4
import QtQuick.LocalStorage 2.0

Item {

    property var db: null

    readonly property string lastVersion: "1.2";

    function connect() {
        if (db !== null) {
            return;
        }

        db = LocalStorage.openDatabaseSync("trolly", "", "Trolly DB", 100 * 1024);

        if (db.version !== lastVersion) {
            upgradeDb();
        }
    }

    function upgradeDb() {

        var sqlcode = [
            'CREATE TABLE IF NOT EXISTS ShoppingList(itemName TEXT, checked NUMBER)',
            'CREATE TABLE IF NOT EXISTS Settings(key TEXT UNIQUE, value TEXT)',
            'DELETE FROM ShoppingList WHERE rowid NOT IN (SELECT MIN(rowid) FROM ShoppingList GROUP BY itemName)',
            'CREATE UNIQUE INDEX shopping_list_item_name on ShoppingList(itemName)'
        ]

        try {
            db.changeVersion(db.version, lastVersion,
                function(tx) {
                    if (db.version < 1.0) {
                        tx.executeSql(sqlcode[0]);
                        console.log('Database upgraded to 1.0');
                    }
                    if (db.version < 1.1) {
                        tx.executeSql(sqlcode[1]);
                        console.log('Database upgraded to 1.1');
                    }
                    if (db.version < 1.2) {
                        tx.executeSql(sqlcode[2]);
                        tx.executeSql(sqlcode[3]);
                        console.log('Database upgraded to 1.2');
                    }
                }
            );
        } catch (err) {
            console.log("Error upgrading database: " + err);
        };
    }
}
