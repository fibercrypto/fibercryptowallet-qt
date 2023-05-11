import QtQuick
import QtQuick.Controls.Material

Item {
    id: root

    readonly property bool itemVisible: addressSky > 0 || emptyAddressVisible
    property bool showOnlyAddresses: false

    signal qrCodeRequested(var data)

    onQrCodeRequested: function(data) {
        dialogQrCode.dataToEncode = data
        dialogQrCode.open()
    }

    implicitHeight: itemVisible ? 30 : 0
    opacity: itemVisible ? 1.0 : 0.0

    Label {
        id: labelNumber

        x: 10
        y: ~~((parent.height - height)/2)
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        visible: !showOnlyAddresses
        text: index + 1
    }

    ToolButton {
        id: toolButtonQR

        x: ~~(labelNumber.x + labelNumber.width)
        y: ~~((parent.height - height)/2)
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        padding: 0
        icon.source: "qrc:/images/icons/actions/qr.svg"
        onClicked: {
            qrCodeRequested(address)
        }
    }

    Label {
        id: labelAddress

        x: toolButtonQR.width + 12
        y: ~~((parent.height - height)/2)
        width: !showOnlyAddresses ? toolButtonCopy.x - x : parent.width
        elide: Label.ElideRight
        text: address // a role of the model
        font.family: "Code New Roman"
    }

    TextInput {
        id: textAddress

        readOnly: true
        visible: false
        text: labelAddress.text
    }

    ToolButton {
        id: toolButtonCopy

        x: labelAddressSky.x - 32
        y: ~~((parent.height - height)/2)
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        visible: !showOnlyAddresses
        icon.source: "qrc:/images/icons/actions/content_copy.svg"
        ToolTip.text: qsTr("Copy to clipboard")
        ToolTip.visible: hovered // TODO: pressed when mobile?
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

        ToolButton {
            id: toolButtonAddressCopied

            x: ~~((parent.width - width)/2)
            y: ~~((parent.height - height)/2)

            enabled: false
            background: null
            opacity: 0.0
            visible: !showOnlyAddresses
            Material.accent: Material.Teal
            icon.source: "qrc:/images/icons/actions/done.svg"
            icon.width: ~~toolButtonCopy.width
            icon.height: ~~toolButtonCopy.height
            icon.color: Material.accentColor
        }

        onClicked: {
            textAddress.selectAll()
            textAddress.copy()
            textAddress.deselect()
            if (copyAnimation.running) {
                copyAnimation.restart()
            } else {
                copyAnimation.start()
            }
        }

        SequentialAnimation {
            id: copyAnimation
            NumberAnimation { target: toolButtonAddressCopied; property: "opacity"; to: 1.0; easing.type: Easing.OutCubic }
            PauseAnimation { duration: 1000 }
            NumberAnimation { target: toolButtonAddressCopied; property: "opacity"; to: 0.0; easing.type: Easing.OutCubic }
        }
    } // ToolButton

    Label {
        id: labelAddressSky

        x: labelAddressCoinsHours.x - width
        y: ~~((parent.height - height)/2)
        width: visible ? 70 : 0
        height: visible ? implicitHeight : 0
        horizontalAlignment: Text.AlignRight
        elide: Label.ElideRight
        visible: !showOnlyAddresses
        color: Material.accent

        text: addressSky === qsTr("N/A") ? "" : addressSky // a role of the model

        BusyIndicator {
            x: parent.width - width
            y: ~~((parent.height - height)/2)
            implicitWidth: implicitHeight
            implicitHeight: parent.height + 10
            running: addressSky === qsTr("N/A") ? true : false
        }
    }

    Label {
        id: labelAddressCoinsHours

        y: ~~((parent.height - height)/2)
        x: parent.width - width - 10
        width: visible ? 70 : 0
        height: visible ? implicitHeight : 0
        horizontalAlignment: Text.AlignRight
        leftPadding: 4
        visible: !showOnlyAddresses
        text: addressCoinHours // a role of the model
        elide: Label.ElideRight
    }
}
