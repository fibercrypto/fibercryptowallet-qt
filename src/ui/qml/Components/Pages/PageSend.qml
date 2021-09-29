import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Dialogs" as Dialogs
import "../Custom" as Custom

Page {
    id: root

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
        Material.primary: applicationWindow.accentColor
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
                dialogSendTransaction.showPasswordField =  false//isEncrypted// get if the current wallet is encrypted
                //dialogSendTransaction.previewDate = "2019-02-26 15:27"               
                dialogSendTransaction.previewType = TransactionDetails.Type.Send
                dialogSendTransaction.previewAmount = txn.amount
                dialogSendTransaction.previewHoursReceived = txn.hoursTraspassed
                dialogSendTransaction.previewHoursBurned = txn.hoursBurned
                dialogSendTransaction.previewtransactionID = txn.transactionId
                dialogSendTransaction.inputs = txn.inputs
                dialogSendTransaction.outputs = txn.outputs
                dialogSendTransaction.walletsAddresses = addrs
                dialogSendTransaction.open()
                */
            }
        }
    } // ToolBar (footer)

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentHeight: switchAdvancedMode.implicitHeight + (switchAdvancedMode.checked ? pageSendAdvanced.implicitHeight : pageSendSimple.implicitHeight)

        SwitchDelegate {
            id: switchAdvancedMode

            x: 10
            y: 10
            text: qsTr("Advanced mode")
        }

        PageSendSimple {
            id: pageSendSimple

            x: switchAdvancedMode.x + 6
            y: switchAdvancedMode.y + switchAdvancedMode.height + 10
            width: parent.width - 2*x
            activated: !switchAdvancedMode.checked
        }

        PageSendAdvanced {
            id: pageSendAdvanced

            x: switchAdvancedMode.x + 6
            y: switchAdvancedMode.y + switchAdvancedMode.height + 6
            width: parent.width - 2*x
            visible: !pageSendSimple.visible
        }

        ScrollBar.vertical: Custom.CustomScrollBar {}
    } // Flickable

    /*
    DialogSendTransaction {
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
            signerSelected = stackView.currentItem.simplePage.getSignerSelected()
            walletManager.signAndBroadcastTxnAsync(walletsAddresses[1], walletsAddresses[0],signerSelected, bridgeForPassword, [], txn)
        }
    }

    DialogGetPassword{
        id: getPasswordDialog
        anchors.centerIn: Overlay.overlay
        property int nAddress
        width: applicationWindow.width > 540 ? 540 - 120 : applicationWindow.width - 40
        height: applicationWindow.height > 570 ? 570 - 180 : applicationWindow.height - 40

        focus: true
        modal: true
        onClosed:{
            bridgeForPassword.setResult(getPasswordDialog.password)
            bridgeForPassword.unlock()
        }
    }

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
