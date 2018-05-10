import QtQuick 2.4
import QtQuick.Layouts 1.1

import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItems
import Ubuntu.Layouts 1.0

import "../service"

import "../dao/ShoppingListDao.js" as ShoppingListDao

/*
  When the user press the "Clear List" button in the right menu bar; the itmes in the list are removed (NOT deleted form the DB)
  That items will appear in this page
 */
Page {
    id: historyPage

    header: PageHeader {
    id: pageHeader
    title: i18n.tr("History (swipe item for options)")

        trailingActionBar.actions:[
            Action {
                id: deleteList
                text: i18n.tr("Delete all")
                iconName: "edit-delete"
                onTriggered: askToDeleteAllItems()  /* Remove items permanently from history the DB */
                enabled: historyListModel.count > 0 /* enable only if there are items to show */
            }
       ]
    }

    /* the items in the History */
    ListModel {
        id: historyListModel
    }

    Layouts {
        id: layouts
        width: parent.width
        height: parent.height
        anchors.topMargin: units.gu(30) /* amount of space from the above component */

        layouts: [
            /* Layout if history is EMPTY */
            ConditionalLayout {
                name: "placeholder"
                when: historyListModel.count === 0
                Label {
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                        topMargin: units.gu(8)
                    }
                    wrapMode: Text.Wrap
                    fontSize: "large"
                    text: i18n.tr("No items in history.\nItems appear here after you remove them from the list with Clear list button.")
                }
            },

            /* Layout used IF history is NOT EMPTY */
            ConditionalLayout {
                name: "content"
                when: historyListModel.count > 0
                    UbuntuListView {
                        id: historyListView
                        anchors.fill: parent
                        anchors.topMargin: units.gu(8) /* amount of space from the above component */
                        model: historyListModel
                        clip: true
                        focus: true
                        highlight: HighlightHistoryComponent{}
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: ListItem {
                            id: historyListItem
                            divider.visible: false /* hide the line item divider */
                            Label {
                                id: label
                                text: itemName
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                                horizontalAlignment: settingsRepository.alignToCenter.value === 'true' ? Text.AlignHCenter : Text.AlignLeft
                                width: parent.width
                            }

                            /*  Swipe to right movement Action: remove item permanently from history and DB */
                            leadingActions: ListItemActions {
                                actions: [
                                    Action {
                                        iconName: "delete"
                                        onTriggered: {
                                            var itemName = historyListModel.get(index).itemName;
                                            ShoppingListDao.db_delete(itemName);
                                            historyListModel.remove(index);
                                        }
                                    }
                                ]
                             }

                             /* Swipe to left movement Action: remove from history and add to Iteml list in the Main page */
                             trailingActions: ListItemActions {
                                actions: [
                                    Action {
                                        text: i18n.tr("Move\nto list")
                                        onTriggered: {
                                            moveItemToShoppingList(index);
                                        }
                                    }
                                ]
                                delegate: Rectangle {
                                    color: pressed ? Qt.darker("yellow", 1.1) : "yellow"
                                    width: units.gu(2) + textLabel.width
                                    Label {
                                        id: textLabel
                                        text: action.text
                                        anchors.centerIn: parent
                                        fontSize: "small"
                                    }
                                }
                            }

                            /* check or not the selected item */
                            onClicked: {
                                var listItem = listModel.get(index);
                                /* move the highlight component to the currently selected item */
                                historyListView.currentIndex = index
                            }

                        } //delegate
                  }
            }
        ]
    }

    Component.onCompleted: {
       /* load History items */
       var items = ShoppingListDao.db_load_history();
       historyListModel.clear();
       for(var i = 0; i < items.length; i++) {
           historyListModel.append({itemName: items[i], itemChecked: false});
       }
    }

    ConfirmDialog {
        id: deleteListOkCancelDialog
        dialogTitle: i18n.tr("Delete list")
        dialogText: i18n.tr("Permanently delete all the items in the history?")
        onOk: deleteAllItems()
    }

    function deleteAllItems() {
        ShoppingListDao.db_delete_list(namesOfAllItemsInTheList());
        historyListModel.clear();
    }

    function moveItemToShoppingList(index) {
        var itemName = historyListModel.get(index).itemName;
        listService.add(itemName);
        historyListModel.remove(index);
    }

    function askToDeleteAllItems() {
        deleteListOkCancelDialog.open();
    }

    function namesOfAllItemsInTheList() {
        var itemNames = [];
        for (var i = 0; i < historyListModel.count; i++) {
            var itemName = historyListModel.get(i).itemName;
            itemNames.push(itemName);
        }
        return itemNames;
    }
}
