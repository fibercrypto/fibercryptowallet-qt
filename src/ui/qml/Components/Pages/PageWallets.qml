import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCryptoWallet as Backend

import "../Delegates" as Delegates
import "../Dialogs" as Dialogs

ListView {
    id: walletList

    property string statusIcon // an empty string for no icon

    clip: true
    model: listWallets
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

    delegate: Delegates.DelegateWallet {
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
            id: connectionToggleEncryption
            enabled: false
            target: dialogSimpleInput
            function onAccepted() {
                if (dialogSimpleInput.inputType === Dialogs.DialogSimpleInput.InputType.Text) {
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
            dialogSimpleInput.inputType = encryptionEnabled ? Dialogs.DialogSimpleInput.InputType.NumberText : Dialogs.DialogSimpleInput.InputType.Number
            dialogSimpleInput.promptMessage = qsTr("Enter number of addresses")

            dialogSimpleInput.numericValue = 1

            dialogSimpleInput.textPlaceholder = qsTr("Wallet's password")
            dialogSimpleInput.textEchoMode = encryptionEnabled ? TextField.Password : dialogSimpleInput.textEchoMode
            dialogSimpleInput.textValue = ""

            connectionAddAddress.enabled = true
            dialogSimpleInput.open()
        }

        onToggleEncryptionRequested: {
            if (encryptionEnabled) {
                dialogSimpleInput.inputType = Dialogs.DialogSimpleInput.InputType.Text

                dialogSimpleInput.promptMessage = ""

                dialogSimpleInput.textPlaceholder = qsTr("Wallet's password")
                dialogSimpleInput.textEchoMode = encryptionEnabled ? TextField.Password : dialogSimpleInput.textEchoMode
                dialogSimpleInput.textValue = ""
            } else {
                dialogSimpleInput.inputType = Dialogs.DialogSimpleInput.InputType.TextText
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

    // Roles: name, encryptionEnabled, sky, coinHours
    // Use listModel.append( { "name": value, "encryptionEnabled": value, "sky": value, "coinHours": value } )
    // Or implement the model in the backend (a more recommendable approach)
    ListModel {
        id: listWallets
        ListElement { name: "My first wallet";   hasHardwareWallet: false; encryptionEnabled: true;  sky: 5;    coinHours: 10 }
        ListElement { name: "My second wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 300;  coinHours: 1049 }
        ListElement { name: "My third wallet";   hasHardwareWallet: true;  encryptionEnabled: false; sky: 13;   coinHours: 201 }

        ListElement { name: "My fourth wallet";  hasHardwareWallet: true;  encryptionEnabled: false; sky: 3941; coinHours: 6652 }
        ListElement { name: "My fiveth wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 9;    coinHours: 35448 }
        ListElement { name: "My sixth wallet";   hasHardwareWallet: true;  encryptionEnabled: true;  sky: 439;  coinHours: 685 }

        ListElement { name: "My seventh wallet"; hasHardwareWallet: false; encryptionEnabled: true;  sky: 22;   coinHours: 315 }
        ListElement { name: "My eighth wallet";  hasHardwareWallet: true;  encryptionEnabled: false; sky: 2001; coinHours: 10628 }
        ListElement { name: "My nineth wallet";  hasHardwareWallet: false; encryptionEnabled: true;  sky: 93;   coinHours: 381 }
    }
} // ListView

//    DialogAddLoadWallet {
//        id: dialogAddLoadWallet
//        anchors.centerIn: Overlay.overlay

//        modal: true
//        focus: true

//        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
//        height: applicationWindow.height > 640 ? 640 - 40 : applicationWindow.height - 40
//    }


