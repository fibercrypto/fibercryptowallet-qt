import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    
    implicitHeight: toolButtonQR.implicitHeight

    ToolButton {
        id: toolButtonQR

        padding: 0
        icon.source: "qrc:/images/icons/actions/qr.svg"

        onClicked: {
            qrCodeRequested(modelData)
            //qrCodeRequested(address)
        }
    }

    Label {
        x: toolButtonQR.width
        y: ~~((toolButtonQR.height - height)/2)
        text: modelData//address // model's role
        font.family: "Code New Roman"
    }
}



