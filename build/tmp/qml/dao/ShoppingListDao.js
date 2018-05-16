
  function db_load() {
        var loadedItems = [];

        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM ShoppingList WHERE checked < 2');

                    for(var i = 0; i < rs.rows.length; i++) {
                        var itemName = rs.rows.item(i).itemName;
                        var checked = rs.rows.item(i).checked;
                        var itemDictionary = {itemName: itemName, checked: checked};

                        loadedItems.push(itemDictionary);
                        //console.log('Loaded item ' + itemName + ': ' + checked);
                    }
                }
            );
        } catch (err) {
            console.log("Error reading from database: " + err);
        };

        //console.log('Loaded ' + loadedItems.length + ' items.');
        return loadedItems;
    }

    function db_load_history() {
        var loadedItems = [];

        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT itemName FROM ShoppingList WHERE checked = 2 ORDER BY itemName');

                    for(var i = 0; i < rs.rows.length; i++) {
                        var itemName = rs.rows.item(i).itemName;

                        loadedItems.push(itemName);
                        //console.log('Loaded history item ' + itemName);
                    }
                }
            );
        } catch (err) {
            console.log("Error reading from database: " + err);
        };

        //console.log('Loaded ' + loadedItems.length + ' history items.');
        return loadedItems;
    }

    /* Save a new item in the database. Checked filed can be 0/1 depending on if the item is marked as done or not */
    function db_save(itemName, checked) {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Saving item ' + itemName + ', ' + checked);
                    tx.executeSql('INSERT OR REPLACE INTO ShoppingList VALUES(?, ?)', [ itemName, checked ]);
                }
            );
        } catch (err) {
            console.log("Error saving item to database: " + err);
        };
    }

    function db_update_checked(itemName, checked) {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Updating item ' + itemName + ', ' + checked);
                    tx.executeSql('UPDATE ShoppingList SET checked = ? WHERE itemName = ?', [ checked, itemName ]);
                }
            );
        } catch (err) {
            console.log("Error updating item in database: " + err);
        };
    }

    /* update item name (the user has swiped left) */
    function db_update_name(oldName, newName) {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Renaming item ' + oldName + ' to ' + newName);
                    tx.executeSql('UPDATE ShoppingList SET itemName = ? WHERE itemName = ?', [ newName, oldName ]);
                }
            );
        } catch (err) {
            console.log("Error updating item in database: " + err);
        };
    }

    function db_delete(itemName) {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Deleting item ' + itemName);
                    tx.executeSql('DELETE FROM ShoppingList WHERE itemName = ?', itemName);
                }
            );
        } catch (err) {
            console.log("Error deleting item from database: " + err);
        };
    }

    function db_delete_list(itemNames) {
        if(itemNames.length < 1) {
            return
        }

        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Deleting a list of ' + itemNames.length + ' items.');
                    var placeholders = new Array(itemNames.length).join('?,') + '?'
                    tx.executeSql('DELETE FROM ShoppingList WHERE itemName IN (' + placeholders + ')', itemNames);
                }
            );
        } catch (err) {
            console.log("Error deleting items from database: " + err);
        };
    }

    function db_clear_list(itemNames) {
        if(itemNames.length < 1) {
            return
        }

        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    //console.log('Clearing a list of ' + itemNames.length + ' items.');
                    var placeholders = new Array(itemNames.length).join('?,') + '?'
                    tx.executeSql('UPDATE ShoppingList SET checked = 2 WHERE itemName IN (' + placeholders + ')', itemNames);
                }
            );
        } catch (err) {
            console.log("Error deleting items from database: " + err);
        };
    }
