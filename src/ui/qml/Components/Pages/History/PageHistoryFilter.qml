import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Item {
    id: pageHistoryFilter

    function loadWallets() {
        //modelFilters.loadModel(walletManager.getWallets())
    }

    implicitWidth: 300
    implicitHeight: listViewFilters.contentHeight

    ListView {
        id: listViewFilters
        
        width: parent.width
        height: parent.height
        spacing: 10
        
        model: listWallets//modelFilters
        delegate: UI.DelegateHistoryFilter {
            property var listAddresses
            width: parent? parent.width : width
        }
        
        /*
        WalletModel {
            id: modelFilters
                       
            Component.onCompleted: {
                loadModel(walletManager.getWallets())
            }
        }
        */

        ScrollBar.vertical: UI.CustomScrollBar {}
    }

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
}
