import QtQuick 2.4
import QtQuick.LocalStorage 2.0

import Ubuntu.Components 1.3

import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3

import "../dao/ShoppingListDao.js" as ShoppingListDao


ListItem {
   id: listItem
   width: mainPage.width
   //height: units.gu(5) /* the height of the rectangle that contains an expense in the list */


   divider.visible: false

   /* --------------  Edit item: Shown on Swipe to left movement ------------- */
   Component {
          id: editItemDialog
          Dialog {
              id: dialogue
              contentWidth: units.gu(42)
              title: i18n.tr("Edit")
              TextArea {
                   id: textArea
                   textFormat:TextEdit.PlainText
                   text: listModel.get(index).itemName
                   //height: units.gu(15)
                   //width: parent.width - units.gu(4)
                   readOnly: false
              }

              Row {
                  id: row
                  width: parent.width
                  spacing: units.gu(1)
                  Button {
                      width: parent.width/2
                      text: i18n.tr("Cancel")
                      onClicked: PopupUtils.close(dialogue)
                  }
                  Button {
                      width: parent.width/2
                      text: i18n.tr("Confirm")
                      color: UbuntuColors.green
                      onClicked: {
                          //var oldName = listModel.get(listIndex).itemName;
                          //textArea.text = textArea.displayText
                          var newName = textArea.displayText; //text;

                          //console.log("Old value:"+mainPage.oldValue);
                          //console.log("NEW value:"+newName)

                          listModel.get(index).itemName = newName;

                          /* update item name (the user has swiped left) */
                          ShoppingListDao.db_update_name(mainPage.oldValue, newName);

                          PopupUtils.close(dialogue)
                      }
                  }
              }
          }
      }
      //-----------------------------------------------------------

      /* This mouse region covers the entire delegate */
             MouseArea {
                 id: selectableMouseArea
                 anchors.fill: parent
                 onClicked: {
                   var listItem = listModel.get(index);
                   /* move the highlight component to the currently selected item */
                   listView.currentIndex = index
                   if(settingsRepository.markDisabled.value === false){
                      listItem.checked = listItem.checked === 1 ? 0 : 1;
                      ShoppingListDao.db_update_checked(listItem.itemName, listItem.checked);
                   }

                 }
             }


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
                  /* move selected item, in case of is not selected before */
                  listView.currentIndex = index
                  ShoppingListDao.db_delete(listModel.get(index).itemName);
                  listModel.remove(index);
               }
           }
       ]
   }

   /* Swipe to right movement: edit selected item */
   trailingActions: ListItemActions {
       actions: [
           Action {
               iconName: "edit"
               onTriggered: {

                  listView.currentIndex = index
                  mainPage.oldValue = listModel.get(index).itemName;
                  listIndex = index;
                  PopupUtils.open(editItemDialog);
               }
           }
       ]
   }


} //del
