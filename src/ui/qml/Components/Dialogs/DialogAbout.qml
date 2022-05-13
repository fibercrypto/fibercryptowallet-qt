import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Dialog {
    id: dialogAbout

    signal licenseRequested()

    title: qsTr("About") + " " + Qt.application.name
    standardButtons: Dialog.Close

    onOpened: {
        contentAbout.animate()
    }

    UI.ContentAbout {
        id: contentAbout

        width: parent.width
        height: parent.height
        onLicenseRequested: dialogAbout.licenseRequested()
    }
}
