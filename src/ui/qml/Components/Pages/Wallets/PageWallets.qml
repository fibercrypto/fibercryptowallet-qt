import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCrypto.UI as UI
import FiberCrypto.WalletModel as WalletModel

ListView {
    id: walletList

    property string statusIcon // an empty string for no icon

    clip: true
    model: WalletModel.WalletModel {}

    // header
    headerPositioning: ListView.PullBackHeader
    header: Pane {
        z: 2
        width: parent.width
        height: labelName.height
        padding: 0

        Label {
            id: labelName

            x: 20
            width: labelSky.x
            text: qsTr("Name")
            font.pointSize: 9
        }
        Label {
            id: labelSky

            x: labelCoinHours.x - width
            width: 70
            horizontalAlignment: Text.AlignRight
            text: qsTr("SKY")
            font.pointSize: 9
        }
        Label {
            id: labelCoinHours

            x: parent.width - width - 10
            width: 70
            horizontalAlignment: Text.AlignRight
            text: qsTr("Coin hours")
            font.pointSize: 9
        }
    } // Pane (header)

    delegate: UI.DelegateWallet {
        Connections {
            id: connectionAddAddress
            enabled: false
            target: dialogSimpleInput
            function onAccepted() {
                console.log("Adding addresses")
                // walletManager.newWalletAddress(fileName, dialogSimpleInput.numericValue, dialogSimpleInput.textValue)
                // listAddresses.loadModel(walletManager.getAddresses(fileName))
                connectionAddAddress.enabled = false
            }
        }
        Connections {
            id: connectionEditWallet
            enabled: false
            target: dialogSimpleInput
            function onAccepted() {
                console.log("Editing wallet")
                // var qwallet = walletManager.editWallet(fileName, name)
                // walletModel.editWallet(index, qwallet.name, encryptionEnabled, qwallet.sky, qwallet.coinHours )
                connectionEditWallet.enabled = false
            }
        }
        Connections {
            id: connectionToggleEncryption
            enabled: false
            target: dialogSimpleInput
            function onAccepted() {
                if (dialogSimpleInput.inputType === UI.DialogSimpleInput.InputType.Text) {
                    console.log("Disabling encryption")
                    // encryptionEnabled = walletManager.decryptWallet(fileName, dialogSimpleInput.textValue)
                } else {
                    console.log("Enabling encryption")
                    // encryptionEnabled = walletManager.encryptWallet(fileName, password)
                }
                connectionToggleEncryption.enabled = false
            }
        }

        onAddAddressesRequested: {
            dialogSimpleInput.inputType = encryptionEnabled ? UI.DialogSimpleInput.InputType.TextNumber : UI.DialogSimpleInput.InputType.Number
            dialogSimpleInput.promptMessage = qsTr("Enter number of addresses")

            dialogSimpleInput.numericValue = 1

            dialogSimpleInput.textPlaceholder = qsTr("Wallet's password")
            dialogSimpleInput.textEchoMode = TextField.Password
            dialogSimpleInput.textValue = ""

            connectionAddAddress.enabled = true
            dialogSimpleInput.open()
        }

        onEditWalletRequested: {
            dialogSimpleInput.inputType = encryptionEnabled ? UI.DialogSimpleInput.InputType.TextText : UI.DialogSimpleInput.InputType.Text
            dialogSimpleInput.promptMessage = ""

            dialogSimpleInput.textPlaceholder = encryptionEnabled ? qsTr("Password") : qsTr("Name")
            dialogSimpleInput.textEchoMode = encryptionEnabled ? TextField.Password : TextField.Normal
            dialogSimpleInput.textValue = ""

            dialogSimpleInput.textPlaceholder2 = qsTr("Name")
            dialogSimpleInput.textEchoMode2 = TextField.Normal
            dialogSimpleInput.textValue2 = ""

            connectionEditWallet.enabled = true
            dialogSimpleInput.open()
        }

        onToggleEncryptionRequested: {
            if (encryptionEnabled) {
                dialogSimpleInput.inputType = UI.DialogSimpleInput.InputType.Text

                dialogSimpleInput.promptMessage = ""

                dialogSimpleInput.textPlaceholder = qsTr("Wallet's password")
                dialogSimpleInput.textEchoMode = encryptionEnabled ? TextField.Password : dialogSimpleInput.textEchoMode
                dialogSimpleInput.textValue = ""
            } else {
                dialogSimpleInput.inputType = UI.DialogSimpleInput.InputType.TextText
                dialogSimpleInput.promptMessage = qsTr("<b>Warning:</b> We suggest that you encrypt each one of your wallets with a password. If you forget your password, you can reset it with your seed. Make sure you have your seed saved somewhere safe before encrypting your wallet.")

                dialogSimpleInput.textPlaceholder = qsTr("Set password")
                dialogSimpleInput.textEchoMode = TextField.Password
                dialogSimpleInput.textValue = ""

                dialogSimpleInput.textPlaceholder2 = qsTr("Confirm password")
                dialogSimpleInput.textEchoMode2 = TextField.Password
                dialogSimpleInput.textValue2 = ""
            }

            connectionToggleEncryption.enabled = true
            dialogSimpleInput.open()
        }
    }

    populate: Transition {
        id: transitionPopulate

        SequentialAnimation {
            PropertyAction { property: "opacity"; value: 0.0 }
            PauseAnimation {
                duration: transitionPopulate.ViewTransition.index === 0 ? 150 : 150 + (transitionPopulate.ViewTransition.index -  transitionPopulate.ViewTransition.targetIndexes[0]) * 50
            }
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 250; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 250; easing.type: Easing.OutCubic }
            }
        }
    }

    ScrollBar.vertical: UI.CustomScrollBar {}
} // ListView

//    DialogAddLoadWallet {
//        id: dialogAddLoadWallet
//        anchors.centerIn: Overlay.overlay

//        modal: true
//        focus: true

//        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
//        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
//    }


