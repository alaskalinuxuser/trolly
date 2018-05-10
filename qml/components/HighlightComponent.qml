import QtQuick 2.4


/*
 Used by the ListView to highlight the currently selected Item in the shopping/Todo list
*/
Component {
    id: highlightComponent

    Rectangle {
        width: 180; height: 44
        border.color: "black"
        border.width: 2

        radius: 2
        /* move the Rectangle on the currently selected List item with the keyboard */
        y:listView.currentItem.y      
    }
}
