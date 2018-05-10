import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/*
   Confirm dialog opened when user press some action in the main menu leadingActionBar
   Title an content to show is passed as input when the Item is instanced.
*/
Item {

    /* passed as input */
    property string dialogTitle
    property string dialogText

    signal ok

    Component {
        id: dialog

        Dialog {
            id: dialogue
            title: dialogTitle

            /* passed when item is created from the caller */
            Label {
                text: dialogText
                wrapMode: Text.Wrap
            }

            Row {
                id: row
                width: parent.width
                spacing: units.gu(1)
                Button {
                    width: parent.width / 2
                    text: i18n.tr("Cancel")
                    onClicked: PopupUtils.close(dialogue)
                }
                Button {
                    width: parent.width / 2
                    text: i18n.tr("OK")
                    color: UbuntuColors.green
                    onClicked: {
                        ok() /* emit the 'ok' signal */
                        PopupUtils.close(dialogue)
                    }
                }
            }
        }
    }

    function open() {
        PopupUtils.open(dialog)
    }
}
