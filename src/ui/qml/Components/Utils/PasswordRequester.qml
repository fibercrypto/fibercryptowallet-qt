import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Item {
    id: root

    property alias text: textFieldPassword.text
    property alias placeholderText: textFieldPassword.placeholderText
    property alias allowPasswordRecovery: buttonForgot.visible

    signal passwordForgotten()

    function clear() {
        textFieldPassword.clear()
    }

    implicitHeight: textFieldPassword.implicitHeight + (allowPasswordRecovery ? buttonForgot.implicitHeight + 5 : 0)

    UI.TextField {
        id: textFieldPassword

        width: parent.width
        placeholderText: qsTr("Password")
        selectByMouse: true
        echoMode: TextField.Password
        focus: parent.focus
    }

    Button {
        id: buttonForgot

        x: ~~((parent.width - width)/2)
        y: textFieldPassword.height + 10
        width: parent.width
        text: qsTr("I forgot my password")
        flat: true
        highlighted: hovered

        onClicked: {
            passwordForgotten()
        }
    }
}
