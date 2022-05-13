import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

MenuBar {
    id: customMenuBar

    property color foregroundColor: Material.foregroundColor
    property color backgroundColor: Material.dialogColor
    Behavior on foregroundColor { ColorAnimation {} }
    Behavior on backgroundColor { ColorAnimation {} }

    Material.foreground: foregroundColor

    signal aboutRequested()
    signal aboutQtRequested()
    signal licenseRequested()
    signal testRequested()

    Menu {
        title: qsTr("Help")

        UI.CustomMenuItem {
            text: qsTr("About")
            iconSource: "qrc:/images/icons/app/appIcon.png" // svg

            onTriggered: aboutRequested()
            Shortcut {
                sequence: StandardKey.HelpContents
                onActivated: aboutRequested()
            }
        }

        UI.CustomMenuItem {
            text: qsTr("About Qt")
            iconSource: "qrc:/images/icons/qt/qt_logo_green.svg"

            onTriggered: aboutQtRequested()
        }

        UI.CustomMenuItem {
            text: qsTr("License")
            iconSource: "qrc:/images/icons/license.svg"

            onTriggered: licenseRequested()
        }

        UI.CustomMenuItem {
            text: qsTr("Tests")
            iconSource: "qrc:/images/icons/menu/bug_report.svg"

            onTriggered: testRequested()
        }
    } // Menu (help)

    background: Rectangle {
        implicitHeight: 40
        color: customMenuBar.backgroundColor
    }
}
