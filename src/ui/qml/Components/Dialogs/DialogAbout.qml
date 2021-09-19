import QtQuick
import QtQuick.Controls

import "DialogContent" as DialogContent

Dialog {
    id: dialogAbout

    signal licenseRequested()

    title: qsTr("About") + " " + Qt.application.name
    standardButtons: Dialog.Close

    onOpened: {
        contentAbout.animate()
    }

    DialogContent.ContentAbout {
        id: contentAbout

        width: parent.width
        height: parent.height
        onLicenseRequested: dialogAbout.licenseRequested()
    }
}
