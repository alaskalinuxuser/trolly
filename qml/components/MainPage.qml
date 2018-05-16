import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components 1.3

import "../service"
import "../service/SuggestionService.js" as SuggestionService
import "../dao/ShoppingListDao.js" as ShoppingListDao

/* APP home page loaded at startup */
Page {
     id:mainPage

     property string oldValue: ""

     header: PageHeader {
         id: pageHeader
         title: i18n.tr("Trolly")

         /* Actions available in the leadingActionBar (the one on the left side) */
         leadingActionBar.actions: [
            Action {
                  id: openAbout
                  text: i18n.tr("About...")
                  iconName: "help"
                  onTriggered: pageStack.push(aboutPage)
            }
         ]

         /* Actions on rigth main menu bar */
         trailingActionBar.actions:[

            /* show Application settings page */
            Action {
                id: openSettings
                text: i18n.tr("Settings...")
                iconName: "settings"
                onTriggered: pageStack.push(settingsPage)
            },

            /* Remove from the list the items checked (but keep them in the DB)*/
            Action {
                id: checkout
                text: i18n.tr("Checkout")
                iconName: "tick"
                onTriggered: checkoutListDialog.open()
            },

            /* Empty all item list and "move" to history page. On DB item reamins */
            Action {
                id: clearList
                text: i18n.tr("Clear list")
                iconName: "erase"
                onTriggered: clearListOkCancelDialog.open()
            },

            /* Empty list contnet and erase items from DB */
            Action {
                id: deleteList
                text: i18n.tr("Delete list")
                iconName: "edit-delete"
                onTriggered: deleteListOkCancelDialog.open()
            },

            /* Open history page: show items remove from list with "clear list" */
            Action {
                id: openHistory
                text: i18n.tr("History...")
                iconName: "history"
                onTriggered: pageStack.push(historyPage)
            },

            /* Show system clipboard content where pick-up something to add at the list.
               Clipboard contant cn be tokenized using the token type chosen
             */
            Action {
                id: importClipboard
                text: i18n.tr("Import from clipboard...")
                iconName: "edit-paste"
                onTriggered: pageStack.push(clipboardImportPage)
            }
        ]
    }

    property int listIndex: -1

    //edit component

    /* Confirm dialog opened when user press "clear list" form the menu bar. It remove ALL the list items */
    ConfirmDialog {
        id: clearListOkCancelDialog
        dialogTitle: i18n.tr("Clear list?")
        dialogText: i18n.tr("Items will be moved to History page")
        onOk: clearAllItems() /* called when the dialog emit the custom 'ok' signal */
    }

    /* Confirm dialog opened when user press "Delete list" form the menu bar. It delete entry fro List & DB */
    ConfirmDialog {
        id: deleteListOkCancelDialog
        dialogTitle: i18n.tr("Delete list ?")
        dialogText: i18n.tr("Permanently delete all the items ?")
        onOk: deleteAllItems()
    }

    /* Confirm dialog opened when user press "Delete list" form the menu bar. It delete entry from List & DB */
    ConfirmDialog {
        id: checkoutListDialog
        dialogTitle: i18n.tr("Clear Checked items ?")
        dialogText: i18n.tr("Remove PERMANENTLY checked items ?")
        onOk: /* on 'Ok' signal */
        {
           var itemNames = []
           for (var i = listModel.count - 1; i >= 0; i--) {
              var listItem = listModel.get(i)
              if (listItem.checked === 1) {
                  var itemName = listItem.itemName
                  itemNames.push(itemName)

                  listModel.remove(i);
              }
           }
           ShoppingListDao.db_clear_list(itemNames)
        }
    }
    //--------------------------------------------------------------

    /* Load saved items and fill the listModel */
    Component.onCompleted: {
        var loadedItems = ShoppingListDao.db_load();
        listModel.clear();
        for(var i = 0; i < loadedItems.length; i++) {
            listService.addWithStatus(loadedItems[i].itemName, loadedItems[i].checked);
        }
    }

    Column {
        id: mainColumn
        spacing: units.gu(3)
        anchors.fill: parent

        /* transparent placeholder: to place the content under the header */
        Rectangle {
            color: "transparent"
            width: parent.width
            height: units.gu(8)
        }

        Row {
            id: layoutRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)
            width: parent.width

            /* placeholder */
            Label{
              text: " "
            }

            TextField {
                id: textInput
                width: parent.width - units.gu(20)
                placeholderText: i18n.tr("Add an item")
                hasClearButton: true
                onDisplayTextChanged: {
                    showSuggestions(textInput, displayText.length > 0);
                }

                onAccepted: {
                   addToList();
                }

                /* Show the suggestions popUp */
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        textInput.focus = true;
                        showSuggestions(textInput);
                    }
                }
            }

            Button {
                id: addButton
                width: units.gu(15)
                text: i18n.tr("Add")
                onClicked: {
                   if(textInput.text.length > 0) {
                       listService.add(textInput.text);
                       textInput.text = '';
                   }
                }
            }
        }

        Row{
          anchors.horizontalCenter: parent.horizontalCenter
          Label{
             fontSize: "little"
             text: i18n.tr("(Swipe to rigth or left selected item for options)")
          }
        }

    }

    /* List of Itmes to show in the page (don't place inside a Column) */
    UbuntuListView {
          id: listView
          anchors.fill: parent
          model:listModel
          clip: true
          focus: true
          anchors.topMargin: units.gu(23) /* amount of space from the above component */
          highlight: HighlightComponent{}
          /* disable the dragging of the model list elements */
          boundsBehavior: Flickable.StopAtBounds
          delegate: PersistentListDelegate{} /* draw list items and their menu oprions */
      }

      Scrollbar {
          flickableItem: listView
          align: Qt.AlignTrailing
    }

    /* PopUp with items suggestions based on the currently inserted text */
    SuggestionPopup {
         id: suggestionPopup
         onChoose: {
            textInput.text = value
         }
    }


    /*
       Retrieve the entry to show in the suggestion/autocomplete popup based on the currently value inserted textField
    */
    function showSuggestions(textInput, shouldShow) {
        if (typeof shouldShow === "undefined" || shouldShow === null) {
            shouldShow = true;
        }

        if(shouldShow === true) {
            var suggestions = SuggestionService.getSuggestions(textInput.displayText);
            suggestionPopup.open(suggestions, textInput);
        } else {
            suggestionPopup.close();
        }
    }

    function deleteAllItems() {
        ShoppingListDao.db_delete_list(namesOfAllItemsInTheList())
        listModel.clear()
    }

    function clearAllItems() {
        ShoppingListDao.db_clear_list(namesOfAllItemsInTheList())
        listModel.clear()
    }

    function namesOfAllItemsInTheList() {
        var itemNames = []
        for (var i = 0; i < listModel.count; i++) {
            var itemName = listModel.get(i).itemName
            itemNames.push(itemName)
        }
        return itemNames
    }

    function indicesOfAllCheckedItemsInTheList() {
        var itemIndices = []
        for (var i = 0; i < listModel.count; i++) {
            if (listItem.checked === 1) {
                itemNames.push(i)
            }
        }
        return itemIndices
    }

}
