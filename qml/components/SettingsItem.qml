import QtQuick 2.4

QtObject {

    property string key
    property variant value
    property variant defaultValue

    onValueChanged: {
        if (settingsRepository.initialized) {
            if (key !== null && key !== '') {
                console.log("Property " + key + " changed to " + value)
                db_save(key, value)
            }
        } else {
            console.log('Settings repository is not yet initialized, ignoring value change of ' + key)
        }
    }

    function db_save(key, value) {
        storage.connect();

        try {
            storage.db.transaction(
                function(tx) {
                    console.log('Saving setting ' + key + ' = ' + value);
                    tx.executeSql('INSERT OR REPLACE INTO Settings(key, value) VALUES(?, ?)', [ key, value ]);
                }
            );
        } catch (err) {
            console.log("Error saving item to database: " + err);
        };
    }
}
