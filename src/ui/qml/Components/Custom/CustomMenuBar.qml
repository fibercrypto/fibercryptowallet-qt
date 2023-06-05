import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Rectangle {
    id: customMenuBar

    property color foregroundColor: Material.foregroundColor
    property color backgroundColor: Material.dialogColor
    property alias toolButtonTheme: toolButtonTheme
    property bool showTestButton: false

    signal preferencesRequested()
    signal aboutRequested()
    signal aboutQtRequested()
    signal licenseRequested()
    signal testRequested()

    signal themeChangeRequested()
    signal accentColorChangeRequested(var accentColor)

    implicitHeight: menuBar.height
    implicitWidth: menuBar.width + toolButtonTheme.width
    Material.foreground: customMenuBar.foregroundColor
    color: backgroundColor

    MenuBar {
        id: menuBar

        background: null

        Menu {
            title: qsTr("Help")
            verticalPadding: 0

            UI.CustomMenuItem {
                text: qsTr("Preferences")
                iconSource: "qrc:/images/icons/menu/settings.svg" // svg

                onTriggered: preferencesRequested()
                Shortcut {
                    sequence: StandardKey.Preferences
                    onActivated: preferencesRequested()
                }
            }

            MenuSeparator { }

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
                visible: showTestButton
                enabled: visible
                height: visible ? implicitHeight : 0

                onTriggered: testRequested()
            }
        } // Menu (help)
    } // menu bar (MenuBar)

    ToolButton {
        id: toolButtonTheme

        x: buttonTheme.x
        y: ~~((buttonTheme.height - height)/2) - 2

        icon.source: "qrc:/images/icons/night_mode.svg"
        icon.color: Material.theme === Material.Light ? customMenuBar.foregroundColor : "transparent"
        background: null
    }
    ToolButton {
        id: toolButtonThemeAccent

        x: buttonTheme.x + buttonTheme.width - width + 6
        y: toolButtonTheme.y

        icon.source: "qrc:/images/icons/arrows/arrow_drop_down.svg"
        background: null
    }
    Button {
        id: buttonTheme

        x: customMenuBar.width - width - 4
        y: ~~((customMenuBar.height - height)/2)
        width: toolButtonTheme.width + 16
        flat: true
        background: Rectangle {
            implicitWidth: 64
            implicitHeight: buttonTheme.Material.buttonHeight
            radius: height/2
            color: buttonTheme.Material.foreground
            opacity: buttonTheme.down ? 0.2 : buttonTheme.hovered ? 0.1 : 0
            Behavior on opacity { NumberAnimation {} }
        }

        onClicked: {
            themeChangeRequested()
        }
        onPressAndHold: {
            menuThemeAccent.open()
        }

        Menu {
            id: menuThemeAccent

            margins: 12
            padding: 4
            visible: false
            enabled: visible

            readonly property var materialPredefinedColors: [
                Material.Red,
                Material.Pink,
                Material.Purple,
                Material.DeepPurple,
                Material.Indigo,
                Material.Blue,
                Material.LightBlue,
                Material.Cyan,
                Material.Teal,
                Material.Green,
                Material.LightGreen,
                Material.Lime,
                Material.Yellow,
                Material.Amber,
                Material.Orange,
                Material.DeepOrange,
                Material.Brown,
                Material.Grey,
                Material.BlueGrey
            ]

            GridView {
                id: gridViewThemeAccent

                implicitWidth: cellWidth*4
                implicitHeight: contentHeight
                cellWidth: 64
                cellHeight: 64
                model: menuThemeAccent.materialPredefinedColors
                delegate: Item {
                    width: gridViewThemeAccent.cellWidth
                    height: width

                    Rectangle {
                        x: (parent.width - width)/2
                        y: (parent.height - height)/2
                        width: parent.width - (Material.accent === buttonTheme.Material.accent ? 0 : 12)
                        Behavior on width { NumberAnimation { easing.type: Easing.OutQuint } }
                        height: width
                        radius: width/2
                        color: Material.accent
                        border.width: 4
                        border.color: Qt.darker(color)

                        Material.accent: modelData

                        Button {
                            x: parent.border.width
                            y: x
                            width: parent.width - 2*x
                            height: width
                            padding: 0
                            topInset: 0
                            bottomInset: 0

                            flat: true
                            Material.accent: modelData
                            Material.background: Material.accent
                            Material.elevation: 0

                            onClicked: {
                                customMenuBar.accentColorChangeRequested(modelData)
                            }
                        }
                    } // Rectangle
                } // Item (delegate)

                ScrollBar.vertical: UI.ScrollBar {}
            } // GridView (accent)
        } // Popup (accent)
    } // Button (theme)
}
