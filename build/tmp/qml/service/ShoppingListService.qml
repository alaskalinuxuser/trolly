import QtQuick 2.4

import "../dao/ShoppingListDao.js" as ShoppingListDao


/*
  Contains the methods to handle the events on the list item (add, edit, delete)
  if the event require a database access, it perform it with ShoppingListDao Component
*/
Item {

    /* add a new itme to the list and save it in DB. Invoked wehn user press 'Add' button */
    function add(itemName) {
        listService.addWithStatus(itemName, 0);
        ShoppingListDao.db_save(itemName,0);
    }

    /* Add the new Item at the List model (see PersistentList.qml) */
    function addWithStatus(itemName, checked) {
        var itemDictionary = {itemName: itemName, checked: checked};
        var indexToInsert = listModel.count;
        var doAppend = true;
        for(var i = 0; i < listModel.count; i++) {
            var currentItem = listModel.get(i);
            var compareResult = itemName.localeCompare(currentItem.itemName);
            if(compareResult === 0) {
                currentItem.checked = 0;
                doAppend = false;
                break;
            } else if(compareResult < 0) {
                indexToInsert = i;
                break;
            }
        }
        if(doAppend) {
            listModel.insert(indexToInsert, itemDictionary);
        }
    }

}
