import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

ListItem.Standard {

    property string label

    property color itemColor

    id: listItem
    text: label
    control: UbuntuShape {
        backgroundColor: itemColor
        width: units.gu(4)
        height: units.gu(4)
    }
}
