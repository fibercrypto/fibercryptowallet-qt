import QtQuick
import QtQuick.Controls

import "DialogContent" as DialogContent

Dialog {
    id: dialogAboutLicense

    title: qsTr("License")
    standardButtons: Dialog.Close

    DialogContent.ContentAboutLicense {
        id: contentAboutLicense

        width: parent.width
        height: parent.height
    }
}
