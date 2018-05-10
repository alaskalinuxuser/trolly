import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Page {
    id: settingsPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Trolly Settings")
    }

    Column {
        anchors.fill: parent

        /* transparent placeholder: to place the content under the header */
        Rectangle {
           color: "transparent"
           width: parent.width
           height: units.gu(8)
        }

        ListItem.Header { text: i18n.tr("Appearance") }

        /* color for the UNchecked items */
        ListItem.Standard {
            text: i18n.tr("Item in list")
            control: UbuntuShape {
                id: shape
                backgroundColor: settingsRepository.itemInListColor.value
                width: units.gu(4)
                height: units.gu(4)
            }
            onClicked: pageStack.push(colorListPage, {target: settingsRepository.itemInListColor})
            progression: true
        }

        /* color for the checked items */
        ListItem.Standard {
            text: i18n.tr("Item in trolly (checked ones)")
            control: UbuntuShape {
                backgroundColor: settingsRepository.itemInTrollyColor.value
                width: units.gu(4)
                height: units.gu(4)
            }
            onClicked: pageStack.push(colorListPage, {target: settingsRepository.itemInTrollyColor})
            progression: true
        }

        /* alignment of the items in the list */
        ListItem.Standard {
            text: i18n.tr("Align to center")
            control: Switch {
                anchors.verticalCenter: parent.verticalCenter
                checked: (settingsRepository.alignToCenter.value === 'true' ? true : false)
                onCheckedChanged: {
                    settingsRepository.alignToCenter.value = checked.toString()
                }
            }
        }
    }
}
