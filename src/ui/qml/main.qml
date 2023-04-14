import QtQuick
import QtQuick.Controls.Material
import QtQuick.Effects
import Qt5Compat.GraphicalEffects // multieffect mask cannot be used with Item (needed for theme animation)

import FiberCrypto.UI as UI

ApplicationWindow {
    id: applicationWindow

    width: 680
    height: 580
    visible: true
    title: Qt.application.name

    onClosing: {
        settings.setValue("style/theme", Material.theme)
        Qt.quit() // Why the app does not close without this?
    }

    menuBar: UI.CustomMenuBar {
        id: customMenuBar

        foregroundColor: applicationWindowContent.currentPage === UI.ApplicationWindowContent.AvailablePages.CreateWalletPage ? "#ffffff" : applicationWindow.Material.foreground
        backgroundColor: applicationWindowContent.currentPage === UI.ApplicationWindowContent.AvailablePages.CreateWalletPage ? Qt.alpha(customMenuBar.Material.dialogColor, 0.2) : customMenuBar.Material.dialogColor

        onAboutRequested: {
            dialogAbout.open()
        }

        onAboutQtRequested: {
            dialogAboutQt.open()
        }

        onLicenseRequested: {
            dialogAboutLicense.open()
        }

        onTestRequested: {
            console.log("Test requested")
            applicationWindowContent.testPage()
        }

        onThemeChangeRequested: {
            popupThemeChange.visible = true
        }
    }

    UI.ApplicationWindowContent {
        id: applicationWindowContent
        width: parent.width
        height: parent.height
    }

    MultiEffect {
        id: multiEffect

        width: applicationWindowContent.width
        height: applicationWindowContent.height
        source: applicationWindowContent

        blurEnabled: blur > 0
        blurMax: 150
        autoPaddingEnabled: false

        Behavior on blur { NumberAnimation {} }
    }

    //! Application-level actions and dialogs

    // Fullscreen
    Action {
        property int previous: applicationWindow.visibility

        shortcut: StandardKey.FullScreen
        onTriggered: {
            if (applicationWindow.visibility !== Window.FullScreen) {
                previous = applicationWindow.visibility
                applicationWindow.showFullScreen()
            } else {
                applicationWindow.showNormal() // Cannot show maximized directly due to a bug in some window managers
                if (previous === Window.Maximized) {
                    applicationWindow.showMaximized()
                }
            }
        }
    }

    // Input dialogs
    UI.DialogSimpleInput {
        id: dialogSimpleInput

        readonly property real singleItemHeight: applicationWindow.height > (promptMessage ? 220 : 200) ? (promptMessage ? 220 : 200) - 40 : applicationWindow.height - 40
        readonly property real doubleItemHeight: applicationWindow.height > (promptMessage ? 280 : 250) ? (promptMessage ? 280 : 250) - 40 : applicationWindow.height - 40

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width > 300 ? 300 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > implicitHeight + 40 ? implicitHeight : applicationWindow.height - 40
        //height: inputType <= Dialogs.DialogSimpleInput.InputType.Number ? singleItemHeight : doubleItemHeight
        modal: true
        focus: visible
    }

    UI.DialogAddWallet {
        id: dialogAddWallet

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40

        modal: true
        focus: true
    }

    // Other dialogs
    UI.DialogTransactionDetails {
        id: dialogTransactionDetails

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width > 640 ? 640 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > implicitHeight + 40 ? implicitHeight : applicationWindow.height - 40

        modal: true
        focus: visible
    }

    // Help dialogs
    UI.DialogAbout {
        id: dialogAbout

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
        focus: visible
        modal: true

        onLicenseRequested: {
            close()
            dialogAboutLicense.open()
        }
    }

    UI.DialogAboutQt {
        id: dialogAboutQt

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
        focus: visible
        modal: true
    }

    UI.DialogAboutLicense {
        id: dialogAboutLicense

        x: ~~((applicationWindow.width - width)/2)
        y: ~~((applicationWindow.height - height)/2 - menuBar.height)
        width: applicationWindow.width - 40
        height: applicationWindow.height - 40
        focus: visible
        modal: true
    }

    Popup {
        id: popupThemeChange

        y: -customMenuBar.height
        z: dialogAboutLicense.z + 1 // above everything

        onAboutToShow: shaderThemeMask.scheduleUpdate()

        padding: 0
        enter: null
        exit: null
        background: null
        closePolicy: Popup.NoAutoClose

        // Initially, this was done with a screenshot of the current view, but that was computationally costly,
        // so I switched to a dormant shader copy of the view that only updates just before changing theme
        ShaderEffectSource {
            id: shaderThemeMask

            width: applicationWindow.width
            height: applicationWindow.height

            sourceItem: Window.contentItem
            live: false

            enabled: visible
            layer.enabled: visible
            layer.effect: OpacityMask { // MultiEffect's mask only works with Image, not Item-based object
                id: opacityMaskCircularReveal
                invert: applicationWindow.Material.theme === Material.Light

                maskSource: Item {
                    width: shaderThemeMask.width
                    height: shaderThemeMask.height

                    Rectangle {
                        id: rectangleThemeMaskSource
                        // this must match the position of toolButtonTheme in CustomMenuBar

                        x: customMenuBar.toolButtonTheme.x + (customMenuBar.toolButtonTheme.width - width)/2
                        y: customMenuBar.toolButtonTheme.y + (customMenuBar.toolButtonTheme.height - height)/2

                        height: width
                        radius: width/2
                    }
                }

                SequentialAnimation {
                    id: animationDarkMode

                    running: popupThemeChange.visible

                    PauseAnimation { duration: 10 }
                    PropertyAction  {
                        target: applicationWindow
                        property: "Material.theme"
                        value: applicationWindow.Material.theme === Material.Light ? Material.Dark : Material.Light
                    }
                    NumberAnimation {
                        target: rectangleThemeMaskSource
                        property: "width"
                        duration: 700
                        from: applicationWindow.Material.theme === Material.Light ? 2.53 * Math.max(shaderThemeMask.width, shaderThemeMask.height) : 0
                        to:   applicationWindow.Material.theme === Material.Light ? 0 : 2.53 * Math.max(shaderThemeMask.width, shaderThemeMask.height)
                    }
                    PropertyAction  { target: popupThemeChange; property: "visible"; value: false }
                }
            } // mask (OpacityMask)
        } // static image (ShaderEffectSource)
    } // overlay (Popup)
}
