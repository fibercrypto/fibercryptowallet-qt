import QtQuick
import QtQuick.Controls.Material

// import eighter prison or qzxing

Dialog {
    id: dialogQrCode

    property string dataToEncode

    standardButtons: Dialog.Ok

    // Prison barcode or qzxing image provider
    Label {
        width: parent.width
        text: qsTr("Not yet implemented")
        wrapMode: Label.Wrap
    }
}
