import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

/*
  Page with colors chooser
 */
Page {
    id: colorListPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Pick a color")
    }

    property var target

    Column {
        anchors.fill: parent

        ColorListItem {
            label: i18n.tr("Orange")
            itemColor: UbuntuColors.orange
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Light grey")
            itemColor: UbuntuColors.lightGrey
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Dark grey")
            itemColor: UbuntuColors.darkGrey
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Red")
            itemColor: UbuntuColors.red
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Green")
            itemColor: UbuntuColors.green
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Blue")
            itemColor: UbuntuColors.blue
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
        ColorListItem {
            label: i18n.tr("Purple")
            itemColor: UbuntuColors.purple
            onClicked: {
                target.value = itemColor
                pageStack.pop()
            }
        }
    }
}
