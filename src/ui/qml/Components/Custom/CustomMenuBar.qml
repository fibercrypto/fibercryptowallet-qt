import QtQuick
import QtQuick.Controls

MenuBar {
    signal aboutRequested()
    signal aboutQtRequested()
    signal licenseRequested()

    Menu {
        title: qsTr("Help")

        CustomMenuItem {
            text: qsTr("About")
            iconSource: "qrc:/images/icons/app/appIcon.png" // svg

            onTriggered: aboutRequested()
            Shortcut {
                sequence: StandardKey.HelpContents
                onActivated: aboutRequested()
            }
        }

        CustomMenuItem {
            text: qsTr("About Qt")
            iconSource: "qrc:/images/icons/qt/qt_logo_green.svg"

            onTriggered: aboutQtRequested()
        }

        CustomMenuItem {
            text: qsTr("License")
            iconSource: "qrc:/images/icons/license.svg"

            onTriggered: licenseRequested()
        }
    } // Menu (help)
}
