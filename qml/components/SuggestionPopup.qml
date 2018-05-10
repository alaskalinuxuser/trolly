import QtQuick 2.4

import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/*
 Create a popup with items names suggestions for the user. It contains the last item used (NOT yet DB deleted) similar
 at the text that the user want insert.
*/
Item {

    property bool historyOpen: false
    property var popover

    signal choose(string value)

    ListModel {
        id: historyListModel
    }

    Component {
        id: recentItemsPopoverComponent

        Popover {

            id: recentItemsPopover

            UbuntuListView {
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right

                    leftMargin: units.gu(1)
                    rightMargin: units.gu(1)
                }
                height: mainPage.height / 3
                model: historyListModel

                clip: true

                delegate: ListItem {
                    id: listItem

                    divider.visible: false
                    Label {
                        id: label
                        text: itemName

                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        width: parent.width
                    }
                    onClicked: {
                        choose(itemName)
                        PopupUtils.close(recentItemsPopover)
                    }
                }
            }

            onVisibleChanged: historyOpen = visible

            Component.onCompleted: popover = recentItemsPopover
        }
    }

    function open(itemNames, targetComponent) {
        if (itemNames.length > 0) {
            if (! historyOpen) {
                PopupUtils.open(recentItemsPopoverComponent, targetComponent)
                historyOpen = true
            }
            historyListModel.clear()

            for (var i = 0; i < itemNames.length; i++) {
                historyListModel.append({'itemName': itemNames[i]});
            }
        } else {
            close();
        }
    }

    function close() {
        if (typeof popover !== "undefined" && popover !== null) {
            PopupUtils.close(popover)
        }
    }
}
