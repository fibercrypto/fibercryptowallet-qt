import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../../Delegates" as Delegates
import "../../Custom" as Custom

Item {
    id: contentTransactionDetails

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

    property string date: "2000-01-01 00:00"
    property int type: ContentTransactionDetails.TransactionType.Send
    property int status: ContentTransactionDetails.TransactionStatus.Preview
    readonly property string statusString: [ qsTr("Confirmed"), qsTr("Pending"), qsTr("Preview") ][status]
    property real amount: 0
    property string hoursReceived
    property string hoursBurned
    property string transactionID
    property var inputs: []
    property var outputs: []
    //property QAddressList modelInputs
    //property QAddressList modelOutputs

    property alias expanded: toolButtonDetails.checked
    readonly property real biggestLabel: Math.max(labelDate.width, labelStatus.width, labelHours.width, labelTxID.width)

    implicitHeight: itemInputOutputs.y + (expanded ? itemInputOutputs.implicitHeight : 0) + 2
    Behavior on implicitHeight { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }

    Label {
        id: labelDate

        text: qsTr("Date:")
        font.bold: true
    }
    Label {
        x: biggestLabel + 4
        y: labelDate.y
        text: date
    }

    Label {
        id: labelStatus

        y: labelDate.y + labelDate.height + 6
        text: qsTr("Status:")
        font.bold: true
    }
    Label {
        x: biggestLabel + 4
        y: labelStatus.y
        text: statusString
    }

    Label {
        id: labelHours

        y: labelStatus.y + labelStatus.height + 6
        text: qsTr("Hours:")
        font.bold: true
    }
    Label {
        x: biggestLabel + 4
        y: labelHours.y
        text: hoursReceived + ' ' + qsTr("received") + ' | ' + hoursBurned + ' ' + qsTr("burned")
    }

    Label {
        id: labelTxID

        y: labelHours.y + labelHours.height + 6
        text: qsTr("Tx ID:")
        font.bold: true
    }
    Label {
        x: biggestLabel + 4
        y: labelTxID.y
        text: transactionID
    }

    Image {
        id: imageTransactionType

        x: parent.width - Math.max(width, labelTransactionType.width)
        source: "qrc:/images/icons/actions/send.svg"
        sourceSize: "72x72"
        mirror: type === ContentTransactionDetails.TransactionType.Receive
    }
    Label {
        id: labelTransactionType

        x: imageTransactionType.x + (imageTransactionType.width - width)/2
        y: imageTransactionType.y + imageTransactionType.height + 10
        text: (type === ContentTransactionDetails.TransactionType.Receive ? qsTr("Receive") : qsTr("Send")) + ' ' + amount + ' ' + qsTr("SKY")
        font.bold: true
        font.pointSize: Qt.application.font.pointSize * 1.15
    }

    ToolButton {
        id: toolButtonDetails

        x: -leftPadding
        y: labelTransactionType.y + labelTransactionType.height
        checkable: true
        icon.source: "qrc:/images/icons/arrows/chevron_" + (checked ? "more" : "less") + ".svg"
    }

    Rectangle {
        x: toolButtonDetails.x + toolButtonDetails.width
        y: toolButtonDetails.y + ~~((toolButtonDetails.height - height)/2)
        width: parent.width - x
        height: 1
        color: Material.color(Material.Grey)
    }

    Item {
        id: itemInputOutputs

        x: labelDate.x
        y: toolButtonDetails.y + toolButtonDetails.height
        width: parent.width
        height: parent.height - y
        implicitHeight: labelInputs.height + 4 + Math.max(listViewInputs.contentHeight, listViewOutputs.contentHeight)
        opacity: expanded ? 1 : 0
        visible: opacity > 0
        enabled: visible

        Behavior on opacity { NumberAnimation { duration: 150 } }

        Label {
            id: labelInputs

            text: qsTr("Inputs")
            font.bold: true
            font.italic: true
        }

        ListView {
            id: listViewInputs

            ToolButton {
                onClicked: console.log(listViewInputs.width, listViewInputs.contentWidth, listViewInputs.height, listViewInputs.contentHeight)
            }

            y: labelInputs.height + 6
            width: ~~(parent.width/2 - 2)
            height: parent.height - y
            spacing: 4
            clip: true
            Material.foreground: Material.Grey
            model: listModelInputs
            delegate: Delegates.DelegateInputOutput {
                width: parent.width
            }

            ScrollBar.vertical: Custom.CustomScrollBar {}
        }

        Label {
            id: labelOutputs

            x: listViewInputs.width + 2
            text: qsTr("Outputs")
            font.bold: true
            font.italic: true
        }

        ListView {
            id: listViewOutputs

            x: labelOutputs.x
            y: labelOutputs.height + 6
            width: ~~(parent.width/2)
            height: parent.height - y
            spacing: 4
            clip: true
            Material.foreground: Material.Grey
            model: listModelOutputs
            delegate: Delegates.DelegateInputOutput {
                width: parent.width
            }

            ScrollBar.vertical: Custom.CustomScrollBar {}
        }
    } // Item (inputs and outputs)

    // Roles: address, addressSky, addressCoinHours
    // Use listModel.append( { "address": value, "addressSky": value, "addressCoinHours": value } )
    // Or implement the model in the backend (a more recommendable approach)
    ListModel {
        id: listModelInputs
        ListElement { address: "qrxw7364w8xerusftaxkw87ues"; addressSky: 30; addressCoinHours: 1049 }
        ListElement { address: "8745yuetsrk8tcsku4ryj48ije"; addressSky: 12; addressCoinHours: 16011 }
    }
    ListModel {
        id: listModelOutputs
        ListElement { address: "734irweaweygtawieta783cwyc"; addressSky: 38; addressCoinHours: 5048 }
        ListElement { address: "ekq03i3qerwhjqoqh9823yurig"; addressSky: 61; addressCoinHours: 9456 }
        ListElement { address: "1kjher73yiner7wn32nkuwe94v"; addressSky: 1; addressCoinHours: 24 }
        ListElement { address: "oopfwwklfd34iuhjwe83w3h28r"; addressSky: 111; addressCoinHours: 13548 }
    }
    //QAddressList{
    //    id: listModelInputs
    //}
    //QAddressList{
    //    id: listModelOutputs
    //}
}
