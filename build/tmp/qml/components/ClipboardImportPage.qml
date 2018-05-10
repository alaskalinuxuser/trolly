import QtQuick 2.4
import QtQuick.Layouts 1.1

import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import Ubuntu.Layouts 1.0

import "../service"

import "../service/StringTokenizer.js" as StringTokenizer


/*
   Show the system clipboard content (text cpoyed with ctrl+c when App is running).

   NOTE: the clipboard text content is splitted using the separator(s) chosen in 'tokenizerSettingsPage' Page

   The user can choose the entryes to import in the shopping-list moving the switch placed on each entry:
   If Switch: ON --> entry will be imported in the list when pressing "import" button
 */
Page {
    id: clipboardImportPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Clipboard Import")

        /* Actions on rigth main menu action bar */
        trailingActionBar.actions:[

            Action {
                id: reload
                text: i18n.tr("Reload")
                iconName: "reload"
                onTriggered: importFromClipboard()
            },

            Action {
                id: openSettings
                text: i18n.tr("Settings...")
                iconName: "settings"
                onTriggered: pageStack.push(tokenizerSettingsPage)
            }
        ]
    }

    property var tokens: null;

    ListModel {
        id: clipboardListModel
    }

    Layouts {
        id: layouts
        anchors.fill: parent
        anchors.topMargin: units.gu(8) /* amount of space from the above component */

        layouts: [
            /* Clipboard is EMPTY */
            ConditionalLayout {
                name: "placeholder"
                when: tokens.length === 0

                Label {
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                        topMargin: units.gu(8)
                    }
                    wrapMode: Text.Wrap
                    fontSize: "large"
                    text: i18n.tr("There is no text in the clipboard.\nPlease copy some text from another application first")
                }
            },

            /* Clipboard is NOT EMPTY */
            ConditionalLayout {
                name: "content"
                when: tokens.length > 0

                ColumnLayout {
                    spacing: units.gu(1)
                    anchors {
                        margins: units.gu(2)
                        fill: parent
                    }

                    UbuntuListView {
                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        Layout.fillHeight: true
                        model: clipboardListModel
                        clip: true

                        delegate: ListItems.Standard {
                            id: clipboardListItem

                            /*
                               depending on the switch status, the entry can be imported in item list pressing "import" button
                               ie: switch OFF: entry not importer
                            */
                            control: Switch {
                                anchors.verticalCenter: parent.verticalCenter
                                checked: tokenChecked
                                onCheckedChanged: {
                                    clipboardListModel.get(index).tokenChecked = checked
                                }
                            }

                            Label {
                                id: label
                                text: tokenLabel
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    Button {
                        id: importButton
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: i18n.tr("Import to list")

                        onClicked: {
                            //console.log("Import form clipboard: " + clipboardListModel.count+" item")
                            for(var i = 0; i < clipboardListModel.count; i++) {
                                var element = clipboardListModel.get(i)
                                if(element.tokenChecked === true) {
                                    //console.log('importing token:' + element.tokenLabel)
                                    listService.add(element.tokenLabel)
                                }
                            }
                            // return to the shopping-list page
                            pageStack.pop()
                        }
                    }
                }
            }
        ]
    }

    Component.onCompleted: {
        console.log('clipboard loaded')
        importFromClipboard();
    }



    function importFromClipboard() {
        console.log('Importing from clipboard: ' + Clipboard.data.text)
        tokens = StringTokenizer.tokenize(Clipboard.data.text, getSeparators())

        clipboardListModel.clear()
        for(var i = 0; i < tokens.length; i++) {
            clipboardListModel.append({tokenLabel: tokens[i], tokenChecked: true})
        }
    }

    function getSeparators() {
        var separators = []
        if(settingsRepository.separatorComma.value === 'true') {
            separators.push(',');
        }
        if(settingsRepository.separatorNewLine.value === 'true') {
            separators.push('\n');
        }
        if(settingsRepository.separatorSpace.value === 'true') {
            separators.push(' ');
        }
        return separators
    }
}
