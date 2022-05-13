import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Dialog {
    id: dialogAboutQt

    title: qsTr("About") + " Qt"
    standardButtons: Dialog.Close

    UI.ContentAboutQt {
        id: contentAboutQt

        width: parent.width
        height: parent.height
    }
}
