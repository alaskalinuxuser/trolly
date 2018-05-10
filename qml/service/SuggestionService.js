
/*
  Function to return hte last inserted item to fill a Popup attached at the input text providing
  a suggestion/autocomplete for the user.
  The suggested values are similar at the text curretnly inserted in the input textInput
*/

 function getSuggestions(input) {
        storage.connect();

        /* amount of entry to return */
        var maxlen = 5;

        var suggestions = [];
        var prefix = input.replace(/'/g, "\\'");

        try {
            storage.db.transaction(
                function(tx) {
                    var rs = tx.executeSql(
                                "SELECT `itemName` FROM `ShoppingList` " +
                                "WHERE `itemName` LIKE '" + prefix + "%' " +
                                "ORDER BY `checked` DESC, `_rowid_` DESC " +
                                "LIMIT " + maxlen);

                    for (var i = 0; i < rs.rows.length; i++) {
                        var itemName = rs.rows.item(i).itemName;
                        suggestions.push(itemName);
                    }
                }
            );
        } catch (err) {
            console.log("Error reading suggestions from database: " + err);
        };

        return suggestions;
  }
