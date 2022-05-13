import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id: root

    readonly property bool itemVisible: addressSky > 0 || emptyAddressVisible
    property bool showOnlyAddresses: false

    signal qrCodeRequested(var data)

    onQrCodeRequested: function(data) {
        genQR(data)
    }

    function genQR(data) {
        console.log("QR requested...")
    }

    implicitHeight: itemVisible ? 30 : 0
    opacity: itemVisible ? 1.0 : 0.0

    Label {
        id: labelNumber

        x: 10
        y: (parent.height - height)/2
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        visible: !showOnlyAddresses
        text: index + 1
    }

    ToolButton {
        id: toolButtonQR

        x: labelNumber.x + ~~labelNumber.width // ~~ to avoid subpixel alignment
        y: (parent.height - height)/2
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        padding: 0
        icon.source: "qrc:/images/icons/actions/qr.svg"
        onClicked: {
            qrCodeRequested(address)
        }
    }

    TextInput {
        id: textAddress

        x: toolButtonQR.width + 12
        y: (parent.height - height)/2
        width: !showOnlyAddresses ? toolButtonCopy.x - x : parent.width
        text: address // a role of the model
        readOnly: true
        font.family: "Code New Roman"
    }
    ToolButton {
        id: toolButtonCopy

        x: labelAddressSky.x - 32
        y: (parent.height - height)/2
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        visible: !showOnlyAddresses
        icon.source: "qrc:/images/icons/actions/content_copy.svg"
        ToolTip.text: qsTr("Copy to clipboard")
        ToolTip.visible: hovered // TODO: pressed when mobile?
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

        Image {
            id: imageCopied

            x: (parent.width - width)/2
            y: (parent.height - height)/2
            width: visible ? implicitWidth : 0
            height: visible ? implicitHeight : 0
            visible: !showOnlyAddresses
            source: "qrc:/images/icons/actions/done.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(toolButtonCopy.icon.width*1.5, toolButtonCopy.icon.height*1.5)
            opacity: 0.0
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
            NumberAnimation { target: imageCopied; property: "opacity"; to: 1.0; easing.type: Easing.OutCubic }
            PauseAnimation { duration: 1000 }
            NumberAnimation { target: imageCopied; property: "opacity"; to: 0.0; easing.type: Easing.OutCubic }
        }
    } // ToolButton

    Label {
        id: labelAddressSky

        x: labelAddressCoinsHours.x - width
        y: (parent.height - height)/2
        width: visible ? 70 : 0
        height: visible ? implicitHeight : 0
        horizontalAlignment: Text.AlignRight
        visible: !showOnlyAddresses
        color: Material.accent

        text: addressSky === qsTr("N/A") ? "" : addressSky // a role of the model

        BusyIndicator {
            x: parent.width - width
            y: (parent.height - height)/2
            implicitWidth: implicitHeight
            implicitHeight: parent.height + 10
            running: addressSky === qsTr("N/A") ? true : false
        }
    }

    Label {
        id: labelAddressCoinsHours

        y: (parent.height - height)/2
        x: parent.width - width - 10
        width: visible ? 70 : 0
        height: visible ? implicitHeight : 0
        horizontalAlignment: Text.AlignRight
        visible: !showOnlyAddresses
        text: addressCoinHours // a role of the model
    }
}
