import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogSendTransaction

    property alias expanded: transactionDetails.expanded
    property bool showPasswordField: false
    property string passwordText

    property alias previewDate: transactionDetails.date                    
    property alias previewType: transactionDetails.type                  
    property alias previewAmount: transactionDetails.amount              
    property alias previewHoursReceived: transactionDetails.hoursReceived
    property alias previewHoursBurned: transactionDetails.hoursBurned    
    property alias previewtransactionID: transactionDetails.transactionID
    property alias inputs : transactionDetails.inputs
    property alias outputs : transactionDetails.outputs

    title: qsTr("Confirm transaction")
    standardButtons: Dialog.Ok | Dialog.Cancel

    onOpened: {
        forceActiveFocus()
        passwordRequester.forceTextFocus()
        standardButton(Dialog.Ok).enabled = passwordRequester.text !== "" || !showPasswordField
    }

    onClosed: {
        passwordRequester.clear()
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentHeight: itemRoot.height

        Item {
            id: itemRoot
            width: parent.width
            height: transactionDetails.height + (itemPasswordField.visible ? itemPasswordField.height + 20 : 0) + 21

            UI.ContentTransactionDetails {
                id: transactionDetails

                width: parent.width
            }

            Rectangle {
                y: transactionDetails.height + 20
                width: parent.width
                height: 1
                visible: expanded
                color: Material.color(Material.Grey)
            }

            Item {
                id: itemPasswordField

                y: transactionDetails.height + (expanded ? 41 : 11)
                width: parent.width
                implicitHeight: labelMsgPassword.height + passwordRequester.height
                opacity: showPasswordField ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation {} }
                visible: opacity > 0

                Label {
                    id: labelMsgPassword
                    width: parent.width
                    text: qsTr("Enter the password to confirm the transaction")
                    wrapMode: Label.Wrap
                    font.bold: true
                }

                UI.PasswordRequester {
                    id: passwordRequester

                    y: labelMsgPassword.height
                    width: parent.width

                    onTextChanged: {
                        dialogSendTransaction.standardButton(Dialog.Ok).enabled = text !== "" || !showPasswordField
                        passwordText = text
                    }
                }
            } // Item (password)
        } // Item (root)

        ScrollBar.vertical: UI.ScrollBar { }
    } // Flickable
}
