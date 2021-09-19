import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Custom" as Custom

import FiberCryptoWallet as Backend

Item {
    id: pageLoadCreateWallet

    property alias mode: backendWalletCreator.mode
    property alias name: backendWalletCreator.name
    property alias seed: backendWalletCreator.seed
    property alias confirmedSeed: backendWalletCreator.confirmedSeed

    signal walletCreationRequested()
    signal walletLoadingRequested()
    
    implicitWidth: 400
    implicitHeight: 400

    Backend.WalletCreator {
        id: backendWalletCreator
    }
    
    Column {
        anchors.fill: parent
        spacing: 30
        
        Custom.CustomSwitch {
            width: parent.width
            height: 70

            leftText: qsTr("New wallet")
            rightText: qsTr("Load wallet")

            backgroundColor: Material.accent

            textColor: Material.accent

            onToggled: {
                pageLoadCreateWallet.mode = isInLeftSide ? Backend.WalletCreator.Create : Backend.WalletCreator.Load
            }
        }

        Button {
            id: buttonCreateLoadWallet

            anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            height: 60

            font.bold: true
            font.pointSize: Qt.application.font.pointSize * 1.2
            text: pageLoadCreateWallet.mode === Backend.WalletCreator.Create ? qsTr("Create") : qsTr("Load")
            highlighted: true
            enabled: pageLoadCreateWallet.mode === Backend.WalletCreator.Load || pageLoadCreateWallet.seed == pageLoadCreateWallet.confirmedSeed
            
            onClicked: {
                if (backendWalletCreator.mode === Backend.WalletCreator.Create) {
                    walletCreationRequested()
                } else {
                    walletLoadingRequested()
                }
            }
        }
    } // Column
}
