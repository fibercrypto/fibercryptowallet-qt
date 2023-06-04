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
 * promptMessage is not empty). As well as reset the properties related to
 * the controls you are about to use.
 */

import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogSimpleInput

    enum InputType { Text, Number, TextText, TextNumber, NumberText }

    property int inputType: DialogSimpleInput.InputType.Text

    property alias promptMessage: contentSimpleInput.promptMessage
    property alias promptMessageColor: contentSimpleInput.promptMessageColor

    property alias textValue: contentSimpleInput.textValue
    property alias textPlaceholder: contentSimpleInput.textPlaceholder
    property alias textColorPlaceholder: contentSimpleInput.textColorPlaceholder
    property alias textEchoMode: contentSimpleInput.textEchoMode

    property alias textValue2: contentSimpleInput.textValue2
    property alias textPlaceholder2: contentSimpleInput.textPlaceholder2
    property alias textColorPlaceholder2: contentSimpleInput.textColorPlaceholder2
    property alias textEchoMode2: contentSimpleInput.textEchoMode2

    property alias numericValue: contentSimpleInput.numericValue
    property alias numericFrom: contentSimpleInput.numericFrom
    property alias numericTo: contentSimpleInput.numericTo
    property alias numericStepSize: contentSimpleInput.numericStepSize

    title: Qt.application.name
    standardButtons: Dialog.Ok | Dialog.Cancel

    UI.ContentSimpleInput {
        id: contentSimpleInput
        width: parent.width
        height: parent.height
    }
}
