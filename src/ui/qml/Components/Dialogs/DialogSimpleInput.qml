/*
 * DOCUMENTATION
 * This dialog is for requesting user input in the following cases:
 * - Requesting a string (like an username or a password)
 * - Requesting a number (an amount)
 * - Requesting two strings (like an username and a password, or two passwords)
 * - Requesting a string and a number (in that order)
 * - Requesting a number and a string (in that order)
 *
 * For that reason, when calling this dialog, you must explicitly set the
 * inputType, and promptMessage properties (and promptMessageColor if
 * promptMessage is not empty). As well as reset the properties related with
 * the controls you are about to use.
 */

import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Dialog {
    id: dialogSimpleInput

    enum InputType { Text, Number, TextText, TextNumber, NumberText }

    property int inputType: DialogSimpleInput.InputType.Text

    property alias promptMessage: labelPrompt.text
    property alias promptMessageColor: labelPrompt.color

    property alias textValue: textField.text
    property alias textPlaceholder: textField.placeholderText
    property alias textColorPlaceholder: textField.placeholderTextColor
    property alias textEchoMode: textField.echoMode

    property alias textValue2: textField2.text
    property alias textPlaceholder2: textField2.placeholderText
    property alias textColorPlaceholder2: textField2.placeholderTextColor
    property alias textEchoMode2: textField2.echoMode

    property alias numericValue: spinBox.value
    property alias numericFrom: spinBox.from
    property alias numericTo: spinBox.to
    property alias numericStepSize: spinBox.stepSize

    title: Qt.application.name
    standardButtons: Dialog.Ok | Dialog.Cancel

    Flickable {
        width: parent.width
        height: parent.height
        contentWidth: width
        contentHeight: labelPrompt.height + textField.height + textField2.height + spinBox.height + 12
        implicitWidth: contentWidth
        implicitHeight: contentHeight
        clip: true

        Label {
            id: labelPrompt

            width: parent.width
            height: text ? implicitHeight : 0
            wrapMode: Label.Wrap
        }

        TextField {
            id: textField

            y: inputType === DialogSimpleInput.InputType.NumberText ? spinBox.y + spinBox.height + 4 : labelPrompt.y + labelPrompt.height + 4
            width: visible ? parent.width : 0
            height: visible ? implicitHeight : 0
            visible: inputType !== DialogSimpleInput.InputType.Number
            focus: visible
            placeholderText: qsTr("Start typing...")
        }

        TextField {
            id: textField2

            y: textField.y + textField.height + 4
            width: visible ? parent.width : 0
            height: visible ? implicitHeight : 0
            visible: inputType === DialogSimpleInput.InputType.TextText
            focus: visible && inputType !== DialogSimpleInput.InputType.TextText
            placeholderText: qsTr("Start typing...")
        }

        SpinBox {
            id: spinBox

            y: inputType === DialogSimpleInput.InputType.TextNumber ? textField.y + textField.height + 4 : labelPrompt.y + labelPrompt.height + 4
            width: visible ? parent.width : 0
            height: visible ? implicitHeight : 0
            visible: inputType !== DialogSimpleInput.InputType.Text && inputType !== DialogSimpleInput.InputType.TextText
            focus: visible && inputType !== DialogSimpleInput.InputType.TextNumber
            from: 1
            to: 100
            value: 1
            editable: true
        }

        ScrollBar.vertical: UI.CustomScrollBar { }
    } // Flickable
}
