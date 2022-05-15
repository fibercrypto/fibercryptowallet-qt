import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import FiberCrypto.UI as UI

Item {
    id: root

    property alias text: textFieldPassword.text
    property alias placeholderText: textFieldPassword.placeholderText
    property alias allowPasswordRecovery: buttonForgot.visible

    signal passwordForgotten()

    function forceTextFocus() {
        textFieldPassword.forceActiveFocus()
    }

    function clear() {
        textFieldPassword.clear()
    }

    implicitHeight: textFieldPassword.implicitHeight + buttonForgot.implicitHeight

    ColumnLayout {
        anchors.fill: parent

        UI.TextField {
            id: textFieldPassword

            placeholderText: qsTr("Password")
            selectByMouse: true
            echoMode: TextField.Password
            focus: true
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
        }

        Button {
            id: buttonForgot
            text: qsTr("I forgot my password")
            flat: true
            highlighted: hovered
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            
            onClicked: {
                passwordForgotten()
            }
        }
    }
}
