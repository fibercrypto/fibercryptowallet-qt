import QtQuick
import QtQuick.Controls.Material

import "../Delegates" as Delegates

ItemDelegate {
    id: root

    // this enums should be in the backend
    enum TransactionStatus {
        Confirmed,
        Pending,
        Preview
    }
    enum TransactionType {
        Send,
        Receive,
        Internal
    }

    property string modelDate: date // showld be date instead of string
    property int modelType: type
    property int modelStatus: status
    property var modelStatusString: [ qsTr("Confirmed"), qsTr("Pending"), qsTr("Preview") ]
    property string modelAmount: amount
    property string modelHoursReceived: hoursTraspassed
    property string modelHoursBurned: hoursBurned
    property string modelTransactionID: transactionID
    property var modelAddresses: addresses.split(",")
    property var modelInputs: addresses.split(",")
    property var modelOutputs: addresses.split(",")
    //property QAddressList modelAddresses: addresses
    //property QAddressList modelInputs: inputs
    //property QAddressList modelOutputs: outputs
    
    signal qrCodeRequested(var data)
    
    onQrCodeRequested: {
        console.log("QR code requested...")
    }

    implicitHeight: 20 + Math.max(labelSendReceive.height + 20 + listViewAddresses.height, toolButtonSendReceive.height) + 10


    ToolButton {
        id: toolButtonSendReceive

        x: 20
        y: 20

        enabled: false
        background: null
        icon.source: "qrc:/images/icons/actions/send.svg"
        icon.width: 32
        icon.height: 32
        icon.color: Material.foreground
        rotation: modelType === DelegateHistoryList.TransactionType.Receive ? 180 : 0
    }

    Label {
        id: labelSendReceive
        x: ~~(toolButtonSendReceive.x + toolButtonSendReceive.width + 20)
        y: ~~(toolButtonSendReceive.y + (toolButtonSendReceive.height - height)/2)
        font.bold: true
        text: (modelType === DelegateHistoryList.TransactionType.Receive ? qsTr("Received") : (modelType === DelegateHistoryList.TransactionType.Send ? qsTr("Sent") : qsTr("Internal"))) + " SKY"
    }

    Label {
        x: labelSendReceive.x + labelSendReceive.width + 20
        y: ~~(labelSendReceive.y + (labelSendReceive.height - height)/2)
        Material.foreground: Material.Grey
        text: modelDate.toLocaleString("2000-01-01 00:00") // model's role
        font.pointSize: Qt.application.font.pointSize * 0.9
    }

    Label {
        x: ~~(parent.width - width - 20)
        y: ~~toolButtonSendReceive.y
        text: (modelType === DelegateHistoryList.TransactionType.Receive ? "" : "-") + amount + " SKY" // model's role
        font.pointSize: Qt.application.font.pointSize * 1.25
        font.bold: true
    }

    ListView {
        id: listViewAddresses

        x: labelSendReceive.x
        y: ~~(labelSendReceive.y + labelSendReceive.height + 10)
        height: contentHeight
        width: parent.width
        spacing: -10
        interactive: false
        model: modelAddresses
        delegate: Delegates.DelegateTransactionAddress {}
    }
}
