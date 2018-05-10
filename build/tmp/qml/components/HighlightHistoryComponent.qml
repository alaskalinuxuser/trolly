import QtQuick 2.4


/*
 Used by HistoryListView to highlight the currently selected Item in the HISTORY list
*/
Component {
    id: highlightComponent2

    Rectangle {
        width: 180; height: 44
        border.color: "blue"
        border.width: 2

        radius: 2
        /* move the Rectangle on the currently selected List item with the keyboard */
        y:historyListView.currentItem.y
    }
}
