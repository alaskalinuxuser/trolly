import QtQuick 2.4
import QtQuick.LocalStorage 2.0

import Ubuntu.Components 1.3

import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3

import "../dao/ShoppingListDao.js" as ShoppingListDao


ListItem {
   id: listItem

   divider.visible: false
   Label {
       id: label
       text: itemName

       font.strikeout: checked === 1
       color: checked === 1 ? settingsRepository.itemInTrollyColor.value : settingsRepository.itemInListColor.value

       verticalAlignment: Text.AlignVCenter
       height: parent.height

       horizontalAlignment: settingsRepository.alignToCenter.value === 'true' ? Text.AlignHCenter : Text.AlignLeft
       width: parent.width
   }

   /* Swipe to right movement: delete selected item */
   leadingActions: ListItemActions {
       actions: [
           Action {
               iconName: "delete"
               onTriggered: {
                 ShoppingListDao.db_delete(listModel.get(index).itemName);
                 listModel.remove(index);
                  // deleteItem(index)
               }
           }
       ]
   }

   /* Swipe to right movment: edit selected item */
   trailingActions: ListItemActions {
       actions: [
           Action {
               iconName: "edit"
               onTriggered: {
                   listIndex = index;
                   PopupUtils.open(editItemDialog);
               }
           }
       ]
   }

   /* check or not the selected item */
   onClicked: {
       var listItem = listModel.get(index);
       /* move the highlight component to the currently selected item */
       listView.currentIndex = index
       listItem.checked = listItem.checked === 1 ? 0 : 1;
       ShoppingListDao.db_update_checked(listItem.itemName, listItem.checked);
   }
} //del
