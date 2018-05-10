import QtQuick 2.4
import Ubuntu.Components 1.3

/*
  Application info and Help page
*/
Page {
    id: aboutPage

    /* versions lower or equal at "1.2.30" are maintained by origna author and not available in the open store */
    readonly property string appVersion: root.appVersion;

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About Trolly")
    }

    Flickable {

        anchors {
            fill: parent
            margins: units.gu(2)
        }

        contentWidth: aboutColumn.width
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            width: parent.parent.width
            spacing: units.gu(2)

            /* transparent placeholder: to place the content under the header */
            Rectangle {
               color: "transparent"
               width: parent.width
               height: units.gu(4)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                fontSize: "large"
                text: i18n.tr("Trolly version")+": " + appVersion
            }

            UbuntuShape {
                anchors.horizontalCenter: parent.horizontalCenter
                width: units.gu(10)
                height: units.gu(10)
                radius: "medium"
                image: Image {
                    source: "trolly.png"
                }
            }

            Label {
                width: parent.width
                fontSize: "medium"
                text: {
                   i18n.tr("Trolly is a shopping list or todo manager application.")+ "<br/>"+
                   i18n.tr("This is a forked version of the original one made by Cos64")+ "<br/>"+ "("+"<a href=\"https://staticdot.com/\">staticdot.com</a>" +")"+"<br/><br/>"+
                   i18n.tr("<strong>Credits:</strong> Thanks to Cos64 for the idea and source code base") + "<br/>"
                }
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                text: {
                    i18n.tr("<strong>List items actions</strong>") + "<br/>"+
                    "<ul>" +
                    "<li>" + i18n.tr("<strong>Touch</strong> to check (or uncheck) a list item") + "</li>" +
                    "<li>" + i18n.tr("<strong>Swipe left</strong> to edit item") + "</li>" +
                    "<li>" + i18n.tr("<strong>Swipe right</strong> to delete item") + "</li>" +
                    "</ul>"
                }
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                text: {
                    i18n.tr("<strong>App Menu actions</strong>") + "<br/>"+
                    "<ul>" +
                    "<li>" + i18n.tr("<strong>Checkout</strong> removes checked items and remembers them") + "</li>" +
                    "<li>" + i18n.tr("<strong>Clear list</strong> removes items and move to history page") + "</li>" +
                    "<li>" + i18n.tr("<strong>Delete list</strong> removes permanently all items") + "</li>" +
                    "</ul>"
                }
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                fontSize: "small"
                text: {
                    "<p>" + i18n.tr("Released under the terms of ") + "GNU GPL v3</p>" +
                    "<p>" + i18n.tr("<strong>Old</strong> source code available on ") + "<a href=\"https://launchpad.net/trolly\">Launchpad</a>" + "</p>"
                }
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
