import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window

// Qt Labs
import Qt.labs.settings 1.0 as QtLabsSettings

Window {
    id: windowSplash

    x: (Screen.width - width)/2
    y: (Screen.height - height)/2
    width: dialogSplash.width + 100
    height: dialogSplash.height + 140
    visible: true
    flags: Qt.SplashScreen | Qt.BypassWindowManagerHint | Qt.CustomizeWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    Material.theme: ~~settings.value("style/theme", Material.Light)

    QtLabsSettings.Settings {
        id: settings
    }

    Dialog {
        id: dialogSplash
        anchors.centerIn: Overlay.overlay
        visible: true
        closePolicy: Dialog.NoAutoClose
        standardButtons: Dialog.Abort

        Component.onCompleted: {
            standardButton(Dialog.Abort).Material.accent = Material.Red
            standardButton(Dialog.Abort).highlighted = true
        }

        onRejected: Qt.exit(-1)
        onClosed: windowSplash.visible = false

        contentWidth: labelApplicationDescription.width
        contentHeight: imageLogo.height + labelApplicationName.height + labelApplicationDescription.height + busyIndicatorLoading.height - 7
        width: implicitWidth + implicitWidth % 2
        height: implicitHeight + implicitHeight % 2

        SequentialAnimation {
            running: true
            loops: 1

            PauseAnimation { duration: 300 }
            ParallelAnimation {
                NumberAnimation {
                    target: labelApplicationName
                    property: "y"
                    duration: 500
                    alwaysRunToEnd: true
                    to: imageLogo.y + imageLogo.height
                    easing.type: Easing.OutBack
                }
                NumberAnimation {
                    target: labelApplicationName
                    property: "scale"
                    duration: 500
                    alwaysRunToEnd: true
                    to: 1
                    easing.type: Easing.OutBack
                }
                SequentialAnimation {
                    PauseAnimation { duration: 100 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: imageLogo
                            property: "opacity"
                            duration: 300
                            alwaysRunToEnd: true
                            to: 1
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: imageLogo
                            property: "scale"
                            duration: 500
                            alwaysRunToEnd: true
                            to: 1
                            easing.type: Easing.OutBack
                        }
                    }
                } // SequentialAnimation
            } // ParallelAnimation
        } // SequentialAnimation

        Image {
            id: imageLogo

            x: (parent.width - width)/2
            source: "qrc:/images/icons/app/appIcon.svg"
            sourceSize: Qt.size(148, 148)
            opacity: 0.0
            scale: 0.9
        }

        Label {
            id: labelApplicationName

            x: (parent.width - width)/2
            y: imageLogo.height/2
            text: Qt.application.name
            font.pixelSize: 24
            font.family: "Hemi Head"
            scale: 1.2
        }

        Label {
            id: labelApplicationDescription

            y: imageLogo.height + labelApplicationName.height
            text: qsTr("Multi-coin cryptocurrency wallet")
            font.pixelSize: 18
            font.italic: true
        }

        BusyIndicator {
            id: busyIndicatorLoading

            x: (parent.width - width - labelLoading.width)/2
            y: labelApplicationDescription.y + labelApplicationDescription.height + 10
            running: visible
            implicitWidth: 32
            implicitHeight: busyIndicatorLoading.implicitWidth
        }
        Label {
            id: labelLoading
            x: busyIndicatorLoading.x + busyIndicatorLoading.width
            y: busyIndicatorLoading.y + (busyIndicatorLoading.height - height)/2
            text: qsTr("Loading...")
            font.italic: true
        }
    } // Dialog

    Loader {
        id: loader

        source: "main.qml"
        asynchronous: true

        Connections {
            target: loader.item
            function onAfterAnimating() { dialogSplash.close(); loader.item.opacity = 1 }
        }

        onLoaded: {
            dialogSplash.standardButton(Dialog.Abort).enabled = false
        }
    }
}
