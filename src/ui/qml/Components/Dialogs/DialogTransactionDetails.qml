import QtQuick
import QtQuick.Controls

import "DialogContent" as DialogContent

Dialog {
    id: dialogTransactionsDetails

    property alias date: transactionDetails.date
    property alias status: transactionDetails.status
    property alias type: transactionDetails.type
    property alias amount: transactionDetails.amount
    property alias hoursReceived: transactionDetails.hoursReceived
    property alias hoursBurned: transactionDetails.hoursBurned
    property alias transactionID: transactionDetails.transactionID
    property alias inputs: transactionDetails.inputs
    property alias outputs: transactionDetails.outputs
    property alias expanded: transactionDetails.expanded

    title: qsTr("Transaction details")
    standardButtons: Dialog.Ok

    onAboutToHide: {
        expanded = false
    }

    DialogContent.ContentTransactionDetails {
        id: transactionDetails

        width: parent.width
        height: parent.height
    }
}
