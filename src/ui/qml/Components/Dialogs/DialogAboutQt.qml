import QtQuick
import QtQuick.Controls

import "DialogContent" as DialogContent

Dialog {
    id: dialogAboutQt

    title: qsTr("About") + " Qt"
    standardButtons: Dialog.Close

    DialogContent.ContentAboutQt {
        id: contentAboutQt

        width: parent.width
        height: parent.height
    }
}
