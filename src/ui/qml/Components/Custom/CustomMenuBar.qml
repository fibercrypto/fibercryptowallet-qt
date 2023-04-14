import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Rectangle {
    id: customMenuBar

    property color foregroundColor: Material.foregroundColor
    property color backgroundColor: Material.dialogColor
    property alias toolButtonTheme: toolButtonTheme

    signal aboutRequested()
    signal aboutQtRequested()
    signal licenseRequested()
    signal testRequested()

    signal themeChangeRequested()
    signal accentColorChangeRequested()

    implicitHeight: menuBar.height
    implicitWidth: menuBar.width + toolButtonTheme.width
    Material.foreground: customMenuBar.foregroundColor
    color: backgroundColor

    MenuBar {
        id: menuBar

        background: null

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
    } // menu bar (MenuBar)

    ToolButton {
        id: toolButtonTheme

        x: customMenuBar.width - width
        y: ~~((customMenuBar.height - height)/2)

        icon.source: "qrc:/images/icons/night_mode.svg"
        icon.color: Material.theme === Material.Light ? customMenuBar.foregroundColor : "transparent"

        onClicked: {
            themeChangeRequested()
        }
    }
}
