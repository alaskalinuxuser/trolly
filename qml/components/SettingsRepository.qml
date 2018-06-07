import QtQuick 2.4
import Ubuntu.Components 1.3

/*
   Keep some user settings about item colors
   TODO: migrate to Settings Components instead of this solution
*/
Item {

    /* lock or unlock Mark item in the list */
    property SettingsItem markDisabled: SettingsItem {
        key: "mark.disabled"
      defaultValue: false.toString()
    }

    property SettingsItem itemInListColor: SettingsItem {
        key: "color.item.in.list"
        defaultValue: UbuntuColors.purple.toString()
    }

    property SettingsItem itemInTrollyColor: SettingsItem {
        key: "color.item.in.trolly"
        defaultValue: UbuntuColors.lightGrey.toString()
    }

    property SettingsItem alignToCenter: SettingsItem {
        key: "align.center"
        defaultValue: true.toString()
    }

    property SettingsItem separatorComma: SettingsItem {
        key: "separator.comma"
        defaultValue: true.toString()
    }

    property SettingsItem separatorNewLine: SettingsItem {
        key: "separator.newline"
        defaultValue: true.toString()
    }

    property SettingsItem separatorSpace: SettingsItem {
        key: "separator.space"
        defaultValue: false.toString()
    }

    readonly property var settingsItems: [
        markDisabled,
        itemInListColor,
        itemInTrollyColor,
        alignToCenter,
        separatorComma,
        separatorNewLine,
        separatorSpace
    ]

    property bool initialized: false

    function db_load() {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Settings');

                    for (var settingIndex = 0; settingIndex < settingsItems.length; settingIndex++) {
                        var loaded = false;
                        var currentSettingItem = settingsItems[settingIndex];
                        //console.log('Trying to load setting ' + currentSettingItem.key)
                        for (var row = 0; row < rs.rows.length; row++) {
                            var key = rs.rows.item(row).key;
                            var value = rs.rows.item(row).value;

                            if (currentSettingItem.key === key) {
                                var currentValue = currentSettingItem.value;
                                if (typeof currentValue === "undefined" || currentValue.toString() !== value) {
                                    currentSettingItem.value = value;
                                    loaded = true;
                                    //console.log('Loaded setting ' + key + ': ' + value);
                                }
                            }
                        }
                        if (! loaded) {
                            currentSettingItem.value = currentSettingItem.defaultValue;
                            //console.log('No saved value found for setting ' + key + ', using default value: ' + currentSettingItem.defaultValue);
                        }
                    }
                    //console.log('Finished reading settings')
                    initialized = true;
                }
            );
        } catch (err) {
            console.log("Error reading from database: " + err);
        };
    }
}
