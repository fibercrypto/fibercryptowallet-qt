import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogAboutLicense

    title: qsTr("License")
    standardButtons: Dialog.Close

    UI.ContentAboutLicense {
        id: contentAboutLicense

        width: parent.width
        height: parent.height
    }
}
