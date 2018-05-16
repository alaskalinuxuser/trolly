import QtQuick 2.4
import Ubuntu.Components 1.3

import "components"
import "service"

MainView {

    id: root
    objectName: "mainView"

    /* applicationName needs to match the "name" field of the click manifest */
    applicationName: "trolly.fulvio"

    property string appVersion : "1.5"  //code base version used: "1.2.30"

    /*------- Tablet (width >= 110) -------- */
    //vertical ok
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal ok
    width: units.gu(100)
    height: units.gu(75)

    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical ok
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)
    /* -------------------------------------- */

    Storage {
      id: storage;
    }

    SettingsRepository {
        id: settingsRepository
    }

    /* keep the list of items to show */
    ListModel {
        id: listModel
    }

    ShoppingListService {
        id: listService
    }

    PageStack {
        id: pageStack

        /* APP home page loaded at startup */
        Component {
            id: mainPage
            MainPage {}
        }

        Component {
            id: settingsPage
            SettingsPage {}
        }

        Component {
            id: clipboardImportPage
            ClipboardImportPage {}
        }

        Component {
            id: tokenizerSettingsPage
            TokenizerSettingsPage {}
        }

        Component {
            id: historyPage
            HistoryPage {}
        }

        Component {
            id: colorListPage
            ColorListPage {}
        }

        Component {
            id: aboutPage
            AboutPage {}
        }

        Component.onCompleted: {
            settingsRepository.db_load();
            push(mainPage)
        }
    }
}
