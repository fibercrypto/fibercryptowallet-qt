import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Page {
    id: pageSend

    property alias advancedMode: switchAdvancedMode.checked
    property string walletSelected
    property string signerSelected
    property string walletEncrypted
    property string destinationAddress
    property string amount
    // property QTransaction txn

    footer: ToolBar {
        id: tabBarSend
        Material.theme: applicationWindow.Material.theme
        Material.primary: applicationWindow.Material.accent
        Material.foreground: applicationWindow.Material.background
        Material.elevation: 0

        ToolButton {
            id: buttonSend
            anchors.fill: parent
            text: qsTr("Send")
            icon.source: "qrc:/images/icons/actions/send.svg"

            onClicked: {
                /*
                var isEncrypted
                var walletSelected
                var walletSelecteds
                if (advancedMode){
                    var outs = stackView.currentItem.advancedPage.getSelectedOutputsWithWallets()
                    var addrs = stackView.currentItem.advancedPage.getSelectedAddressesWithWallets()
                    //walletSelecteds = stackView.currentItem.advancedPage.getSelectedWallet()
                    var destinationSummary = stackView.currentItem.advancedPage.getDestinationsSummary()
                    var changeAddress = stackView.currentItem.advancedPage.getChangeAddress()
                    var automaticCoinHours = stackView.currentItem.advancedPage.getAutomaticCoinHours()
                    var burnFactor = stackView.currentItem.advancedPage.getBurnFactor()
                    if (outs[0].length > 0){
                        txn = walletManager.sendFromOutputs(outs[1], outs[0], destinationSummary[0], destinationSummary[1], destinationSummary[2], changeAddress, automaticCoinHours, burnFactor)
                    } else {
                        if (addrs[0].length == 0){
                            addrs = stackView.currentItem.advancedPage.getAllAddressesWithWallets()                            
                        }
                        txn = walletManager.sendFromAddresses(addrs[1], addrs[0], destinationSummary[0], destinationSummary[1], destinationSummary[2], changeAddress, automaticCoinHours, burnFactor)
                    } 
                    
                    isEncrypted = stackView.currentItem.advancedPage.walletIsEncrypted()
                } else{
                    walletSelected = stackView.currentItem.simplePage.getSelectedWallet()
                    isEncrypted = stackView.currentItem.simplePage.walletIsEncrypted()
                    var addrs = []
                    addrs.push([])
                    addrs.push([])
                    addrs[0].push(stackView.currentItem.simplePage.getDestinationAddress())
                    addrs[1].push(walletSelected)
                    txn = walletManager.sendTo(walletSelected, stackView.currentItem.simplePage.getDestinationAddress(), stackView.currentItem.simplePage.getAmount())
                }
                */
                dialogSendTransaction.showPasswordField = false // isEncrypted // get if the current wallet is encrypted
                dialogSendTransaction.previewDate = "2019-02-26 15:27"
                dialogSendTransaction.previewType = UI.ContentTransactionDetails.TransactionType.Send
                dialogSendTransaction.previewAmount = 4.98
                dialogSendTransaction.previewHoursReceived = 1534
                dialogSendTransaction.previewHoursBurned = 976
                dialogSendTransaction.previewtransactionID = "590b37a927f83a1c9"
                dialogSendTransaction.inputs = []
                dialogSendTransaction.outputs = []
                dialogSendTransaction.walletsAddresses =["9285b393e8205a857f18046", "b2840e9283c8383a928f0f137a9"]
                dialogSendTransaction.open()
            }
        }
    } // ToolBar (footer)

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentHeight: switchAdvancedMode.implicitHeight + (switchAdvancedMode.checked ? pageSendAdvanced.implicitHeight : pageSendSimple.implicitHeight)
        pixelAligned: true

        SwitchDelegate {
            id: switchAdvancedMode

            x: 10
            y: 10
            text: qsTr("Advanced mode")
        }

        UI.PageSendSimple {
            id: pageSendSimple

            x: switchAdvancedMode.x + 6
            y: switchAdvancedMode.y + switchAdvancedMode.height + 10
            width: parent.width - 2*x
            activated: !switchAdvancedMode.checked
        }

        UI.PageSendAdvanced {
            id: pageSendAdvanced

            x: switchAdvancedMode.x + 6
            y: switchAdvancedMode.y + switchAdvancedMode.height + 6
            width: parent.width - 2*x
            activated: !pageSendSimple.activated
        }

        ScrollBar.vertical: UI.ScrollBar {}
    } // Flickable

    UI.DialogSendTransaction {
        id: dialogSendTransaction
        anchors.centerIn: Overlay.overlay
        property var walletsAddresses
        readonly property real maxHeight: (expanded ? 490 : 340) + (showPasswordField ? 140 : 0)
        width: applicationWindow.width > 640 - 40 ? 640 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > maxHeight - 40 ? maxHeight - 40 : applicationWindow.height - 40
        Behavior on height { NumberAnimation { duration: 1000; easing.type: Easing.OutQuint } }
        
        modal: true
        focus: true
		onAccepted: {
            console.log("Send transaction...")
            //signerSelected = stackView.currentItem.simplePage.getSignerSelected()
            //walletManager.signAndBroadcastTxnAsync(walletsAddresses[1], walletsAddresses[0],signerSelected, bridgeForPassword, [], txn)
        }
    }

    /*
    QBridge{
        id: bridgeForPassword

        onGetPassword:{
            getPasswordDialog.title = message
            getPasswordDialog.clear()
            getPasswordDialog.open()
        }
    }
    */
}
