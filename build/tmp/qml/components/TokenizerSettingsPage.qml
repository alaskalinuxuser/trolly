import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItem

/*
  Allow at hte user to specify the separators (comma, dot...) to use to tokenize the text inserted in the Clipboard.
  Each token will be shown in ClipboardImportPage as separated entry.
*/
Page {
    id: tokenizerSettingsPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Clipboard Import Settings")
    }

    Column {
        anchors.fill: parent

        /* transparent placeholder: to place the content under the header */
        Rectangle {
           color: "transparent"
           width: parent.width
           height: units.gu(8)
        }

        ListItem.Header { text: i18n.tr("Separators used to tokenize clipboard entry") }
        ListItem.Standard {
            text: i18n.tr("Comma")
            control: Switch {
                anchors.verticalCenter: parent.verticalCenter
                checked: (settingsRepository.separatorComma.value === 'true' ? true : false)
                onCheckedChanged: {
                    settingsRepository.separatorComma.value = checked.toString()
                }
            }
        }
        ListItem.Standard {
            text: i18n.tr("New line")
            control: Switch {
                anchors.verticalCenter: parent.verticalCenter
                checked: (settingsRepository.separatorNewLine.value === 'true' ? true : false)
                onCheckedChanged: {
                    settingsRepository.separatorNewLine.value = checked.toString()
                }
            }
        }
        ListItem.Standard {
            text: i18n.tr("Space")
            control: Switch {
                anchors.verticalCenter: parent.verticalCenter
                checked: (settingsRepository.separatorSpace.value === 'true' ? true : false)
                onCheckedChanged: {
                    settingsRepository.separatorSpace.value = checked.toString()
                }
            }
        }
    }
}
