import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Custom" as Custom

import Backend.Managers as BackendManagers

Item {
    id: pageLoadCreateWallet

    property alias mode: backendWalletManager.mode
    property alias name: backendWalletManager.name
    property alias seed: backendWalletManager.seed
    property alias confirmedSeed: backendWalletManager.confirmedSeed

    signal walletCreationRequested()
    signal walletLoadingRequested()
    
    implicitWidth: 400
    implicitHeight: 400

    BackendManagers.WalletManager {
        id: backendWalletManager
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
                pageLoadCreateWallet.mode = isInLeftSide ? BackendManagers.WalletManager.Create : BackendManagers.WalletManager.Load
            }
        }

        Button {
            id: buttonCreateLoadWallet

            anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            height: 60

            font.bold: true
            font.pointSize: Qt.application.font.pointSize * 1.2
            text: pageLoadCreateWallet.mode === BackendManagers.WalletManager.Create ? qsTr("Create") : qsTr("Load")
            highlighted: true
            enabled: pageLoadCreateWallet.mode === BackendManagers.WalletManager.Load || pageLoadCreateWallet.seed === pageLoadCreateWallet.confirmedSeed
            
            onClicked: {
                if (backendWalletManager.mode === BackendManagers.WalletManager.Create) {
                    walletCreationRequested()
                } else {
                    walletLoadingRequested()
                }
            }
        }
    } // Column
}
