import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Delegates" as Delegates

ItemDelegate {
    id: root

    enum TransactionType { Send, Receive }

    property string modelDate: date // showld be date instead of string
    property int modelType: type
    property int modelStatus: status
    property var modelStatusString: [ qsTr("Confirmed"), qsTr("Pending"), qsTr("Preview") ]
    property string modelAmount: amount
    property string modelHoursReceived: hoursTraspassed
    property string modelHoursBurned: hoursBurned
    property string modelTransactionID: transactionID
    property var modelAddresses: addresses.split(",")
    //property QAddressList modelAddresses: addresses
    //property QAddressList modelInputs: inputs
    //property QAddressList modelOutputs: outputs
    
    signal qrCodeRequested(var data)
    
    onQrCodeRequested: {
        console.log("QR code requested...")
    }

    implicitHeight: 20 + Math.max(labelSendReceive.height + 20 + listViewAddresses.height, imageSendReceive.height) + 10


    Image {
        id: imageSendReceive

        x: 20
        y: 20
        source: "qrc:/images/icons/actions/send.svg"
        sourceSize: "32x32"
        mirror: modelType === DelegateHistoryList.TransactionType.Receive
    }

    Label {
        id: labelSendReceive
        x: imageSendReceive.x + imageSendReceive.width + 20
        y: imageSendReceive.y + (imageSendReceive.height - height)/2
        font.bold: true
        text: (modelType === DelegateHistoryList.TransactionType.Receive ? qsTr("Received") : (modelType === DelegateHistoryList.TransactionType.Send ? qsTr("Sent") : qsTr("Internal"))) + " SKY"
    }

    Label {
        x: labelSendReceive.x + labelSendReceive.width + 20
        y: labelSendReceive.y + (labelSendReceive.height - height)/2
        Material.foreground: Material.Grey
        text: modelDate.toLocaleString("2000-01-01 00:00") // model's role
        font.pointSize: Qt.application.font.pointSize * 0.9
    }

    Label {
        x: parent.width - width - 20
        y: imageSendReceive.y
        text: (modelType === DelegateHistoryList.TransactionType.Receive ? "" : "-") + amount + " SKY" // model's role
        font.pointSize: Qt.application.font.pointSize * 1.25
        font.bold: true
    }

    ListView {
        id: listViewAddresses

        x: labelSendReceive.x
        y: labelSendReceive.y + labelSendReceive.height + 10
        height: contentHeight
        width: parent.width
        spacing: -10
        interactive: false
        model: modelAddresses
        delegate: Delegates.DelegateTransactionAddress {}
    }
}
