import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

ApplicationWindow {
    id: applicationWindow

    width: 680
    height: 580
    visible: true
    title: Qt.application.name

    onClosing: Qt.quit() // Why the app does not close without this? Also, check if settings are saved properly

    menuBar: UI.CustomMenuBar {
        id: customMenuBar

        foregroundColor: applicationWindowContent.currentPage === UI.ApplicationWindowContent.AvailablePages.CreateWalletPage ? customMenuBar.Material.dialogColor : applicationWindow.Material.foreground
        backgroundColor: applicationWindowContent.currentPage === UI.ApplicationWindowContent.AvailablePages.CreateWalletPage ? "#33FFFFFF" : customMenuBar.Material.dialogColor

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
    }

    UI.ApplicationWindowContent {
        id: applicationWindowContent
        width: parent.width
        height: parent.height
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
                applicationWindow.showNormal() // Cannot show maximized directly due to a bug in some X11 managers
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

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 300 ? 300 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > implicitHeight + 40 ? implicitHeight : applicationWindow.height - 40
        //height: inputType <= Dialogs.DialogSimpleInput.InputType.Number ? singleItemHeight : doubleItemHeight
        modal: true
        focus: visible
    }

    UI.DialogAddWallet {
        id: dialogAddWallet

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40

        modal: true
        focus: true
    }

    // Other dialogs
    UI.DialogTransactionDetails {
        id: dialogTransactionDetails

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 640 ? 640 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > implicitHeight + 40 ? implicitHeight : applicationWindow.height - 40

        modal: true
        focus: visible
    }

    // Help dialogs
    UI.DialogAbout {
        id: dialogAbout

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
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

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
        focus: visible
        modal: true
    }

    UI.DialogAboutLicense {
        id: dialogAboutLicense

        x: (applicationWindow.width - width)/2
        y: (applicationWindow.height - height)/2 - menuBar.height
        width: applicationWindow.width - 40
        height: applicationWindow.height - 40
        focus: visible
        modal: true
    }
}
