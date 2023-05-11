import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogConfirmSeed

    property int word1Number: 1
    property int word2Number: 2
    property int word3Number: 3
    property int word4Number: 4

    readonly property string word1: textFieldTopLeft.text
    readonly property string word2: textFieldTopRight.text
    readonly property string word3: textFieldBottomLeft.text
    readonly property string word4: textFieldBottomRight.text

    title: qsTr("Confirm secret recovery phrase")
    standardButtons: Dialog.Ok | Dialog.Cancel
    focus: visible

    Item {
        id: itemConfirmSeed

        implicitWidth: 540 // seedGenerator.width
        implicitHeight: textFieldTopLeft.height * 2 + 6
        width: parent.width

        UI.TextField {
            id: textFieldTopLeft

            width: ~~(parent.width/2) - 5
            placeholderText: qsTr("Word #%1").arg(word1Number)
            focus: dialogConfirmSeed.focus

            onAccepted: {
                textFieldTopRight.forceActiveFocus()
            }
        }

        UI.TextField {
            id: textFieldTopRight

            x: parent.width - textFieldTopLeft.width
            width: textFieldTopLeft.width
            placeholderText: qsTr("Word #%1").arg(word2Number)

            onAccepted: {
                textFieldBottomLeft.forceActiveFocus()
            }
        }

        UI.TextField {
            id: textFieldBottomLeft

            y: textFieldTopLeft.y + textFieldTopLeft.height + 6
            width: textFieldTopLeft.width
            placeholderText: qsTr("Word #%1").arg(word3Number)

            onAccepted: {
                textFieldBottomRight.forceActiveFocus()
            }
        }

        UI.TextField {
            id: textFieldBottomRight

            x: textFieldTopRight.x
            y: textFieldBottomLeft.y
            width: textFieldTopLeft.width

            placeholderText: qsTr("Word #%1").arg(word4Number)

            onAccepted: {
                if (dialogConfirmSeed.standardButton(Dialog.Ok).enabled === true) {
                    dialogConfirmSeed.accept()
                } // else set focus to error text field?
            }
        }
    } // Item (confirm seed)
}
